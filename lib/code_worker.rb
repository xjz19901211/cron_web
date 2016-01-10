require 'timeout'
require 'shellwords'

class CodeWorker
  TIMEOUT = 10.minutes

  attr_reader :task, :logs, :cid

  class Error < StandardError; end


  def initialize(task)
    @task = task
    @logs = []
  end


  def perform
    start_code_url = "#{Settings.base['host_url']}/tasks/#{task.id}/start_code"
    task.update(status: 'running')
    run_code_vm(start_code_url)
  rescue => e
    task.update(status: 'failed')
    write_log(:error, e.message)
  end


  private

  def run_code_vm(start_code_url)
    cmd = vm_cmd(start_code_url)

    @cid = cid = exec_cmd(cmd)

    if valid_cid?(cid)
      write_log(:info, "container id: #{cid}")
      Thread.new { follow_vm(cid) }
    else
      raise Error, "Docker start failed"
    end
  end

  def docker_cmd
    docker_cmd = "docker run -d"
    docker_cmd += " --net=host" unless Rails.env.production?
    docker_cmd += " #{Settings.code_worker['worker_image']}"
  end

  def vm_cmd(start_code_url)
    "#{docker_cmd} bash -c #{Shellwords.escape("curl #{start_code_url} | bash")}"
  end

  def follow_vm(cid)
    write_log(:info, '# follow worker')
    write_log(:info, '')

    Timeout.timeout(Settings.code_worker['task_timeout']) do
      loop do
        write_log(:info, exec_cmd("docker logs #{cid}", false), false)
        info = MultiJson.load(exec_cmd("docker inspect #{cid}", false)).first
        raise Error, "Cannot inspect container #{cid}" unless info

        break if info['State']['Status'] == 'exited'
        sleep 1
      end
    end

    write_log(:info, "Remove container #{cid}")
    exec_cmd("docker rm #{cid}")
    task.update(status: 'finished')
  rescue => e
    exec_cmd("docker kill #{cid}")
    task.update(status: 'failed')
    write_log(:error, e.message)
  end

  def write_log(level, message, append_log = true)
    level = level.to_s.upcase
    append_log ? (logs << []) : (logs[-1] = [])
    last_logs = logs[-1]

    message.lines.map {|line| last_logs << "[#{level}] #{line.strip}\n" }

    task.update(output: logs.flatten.join)
  end

  def exec_cmd(cmd, print_log = true)
    write_log(:debug, cmd) if print_log
    `#{cmd}`
  end

  def valid_cid?(cid)
    exec_cmd("docker inspect --format=1 #{cid}").strip == '1'
  end
end


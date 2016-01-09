require 'timeout'

class CodeWorker
  TIMEOUT = 10.minutes

  attr_reader :task, :logs


  def initialize(task)
    @task = task
    @logs = []
  end


  def perform
    start_code_url = "#{Setting.base['host_url']}/tasks/#{task.id}/start_code"
    task.update(status: 'running')
    run_code_vm(start_code_url)
  rescue => e
    task.update(status: 'failed')
    write_log(:error, e.mesage)
  end


  private

  def run_code_vm(start_code_url)
    cmd = vm_cmd(start_code_url)

    write_log(:debug, cmd)
    cid = `#{cmd}`
    write_log(:debug, "container id: #{cid}")

    Thread.new { follow_worker(cid) }
  end

  def docker_cmd
    docker_cmd = "docker run -d"
    docker_cmd += " --net=host" unless Rails.env.production?
    docker_cmd += " #{Setting.base['worker_image']}"
  end

  def vm_cmd(start_code_url)
    "#{docker_cmd} bash -c #{Shellwords.escape("curl #{start_code_url} | bash")}"
  end

  def follow_worker(cid)
    write_log(:info, '# follow worker')
    write_log(:info, '')

    Timeout.timeout(TIMEOUT) do
      loop do
        write_log(:info, `docker logs #{cid}`, false)
        info = MultiJson.load(`docker inspect #{cid}`).first

        break if info['State']['Status'] == 'exited'
        sleep 1
      end
    end

    write_log(:info, "Remove container #{cid}")
    `docker rm #{cid}`
    task.update(status: 'finished')
  end

  def write_log(level, message, append_log = true)
    level = level.to_s.upcase
    append_log ? (logs << []) : (logs[-1] = [])
    last_logs = logs[-1]

    message.lines.map {|line| last_logs << "[#{level}] #{line.strip}\n" }

    task.update(output: logs.flatten.join("\n"))
  end
end


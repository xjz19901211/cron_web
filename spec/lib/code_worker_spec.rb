RSpec.describe CodeWorker do
  let(:task) { create_task('t') }
  let(:code_worker) { CodeWorker.new(task) }
  let(:start_code_url) { "#{Settings.base['host_url']}/tasks/#{task.id}/start_code" }

  def mock_cmd(cmd_regexp, &block)
    @mock_cmds[cmd_regexp] = block
  end


  before :each do
    # disable thread
    allow(Thread).to receive(:new) {|&block| block.call }

    @exec_cmd_method = exec_cmd_method = code_worker.method(:exec_cmd).to_proc
    # {'cmd' => proc}
    @mock_cmds = mock_cmds = {}

    allow(code_worker).to receive(:exec_cmd) do |cmd|
      mocks = mock_cmds.select {|str, _| cmd =~ Regexp.new("^#{str}") }
      regexp, block = mocks.sort_by {|str, _| str.length }.last
      regexp ? block.call(cmd) : exec_cmd_method.call(cmd)
    end

    mock_cmd('docker run') { 'container_id' }
    mock_cmd('docker logs') { 'code logs' }
    mock_cmd('docker rm') { 'container_id' }
    mock_cmd('docker inspect --format=1') do |cmd|
      cmd.split.last == 'container_id' ? '1' : '[]'
    end
    mock_cmd('docker inspect') do |cmd|
      if cmd.split.last == 'container_id'
        %q(
          [{
            "Id": "container_id",
            "Created": "2016-01-10T07:28:14.855395632Z",
            "State": {
              "Status": "exited",
              "Running": false,
              "Paused": false,
              "StartedAt": "2016-01-10T07:28:14.901909105Z"
            }
          }]
        )
      else
        '[]'
      end
    end
  end


  before :each, disable_thread: false do
    allow(Thread).to receive(:new) {|&block| block.call }
  end

  before :each, mock_docker: false do
    allow(code_worker).to receive(:exec_cmd).and_call_original
  end


  describe '#perform' do
    it 'should update task status to running' do
      allow(code_worker).to receive(:run_code_vm)

      expect {
        code_worker.perform
      }.to change { task.reload.status }.to('running')
    end

    it 'failed should update task status to failed' do
      allow(code_worker).to receive(:run_code_vm).and_raise('err msg')

      expect {
        code_worker.perform
      }.to change { task.reload.status }.to('failed')

      expect(task.reload.output).to eq("[ERROR] err msg\n")
    end

    it 'should run task code with docker' do
      docker_cmd = "docker run -d --net=host ruby:cron_web"
      escape_bash_cmd = Shellwords.escape("curl #{start_code_url} | bash")
      call_docker_run = false

      mock_cmd('docker run') do |cmd|
        call_docker_run = true
        expect(cmd).to eql("#{docker_cmd} bash -c #{escape_bash_cmd}")
      end

      code_worker.perform
      expect(call_docker_run).to eql(true)
    end

    it 'should follow_vm if start successfully' do
      expect(code_worker).to receive(:follow_vm).with(kind_of(String))
      code_worker.perform
    end

    it 'should write error log, if start failed' do
      mock_cmd('docker run') { 'invalid_cid' }
      expect(code_worker).to_not receive(:follow_vm)

      code_worker.perform
      expect(task.reload.output.lines.last).to eq("[ERROR] Docker start failed\n")
    end

    it 'should update code log' do
      test_log = "#{Time.now.to_i} same code log"
      mock_cmd('docker logs') { test_log }

      code_worker.perform
      expect(task.reload.output).to match(test_log)
    end

    it 'should kill vm if timeout' do
      origin_timeout = Settings.code_worker['task_timeout']
      Settings.code_worker['task_timeout'] = 0.3

      run_docker_kill = false
      mock_cmd('docker logs') { sleep 3 }
      mock_cmd('docker kill') do |cmd|
        run_docker_kill = true
        expect(cmd.split.last).to eq('container_id')
      end

      code_worker.perform
      expect(task.reload.output).to match('execution expired')
      expect(run_docker_kill).to eql(true)

      Settings.code_worker['task_timeout'] = origin_timeout
    end

    it 'should update task status if finish', mock_docker: false do
      exec_cmd_method = @exec_cmd_method
      allow(code_worker).to receive(:exec_cmd) do |cmd|
        if cmd =~ /^docker run/
          exec_cmd_method.call(cmd.split('curl').first + 'echo hello')
        else
          exec_cmd_method.call(cmd)
        end
      end

      code_worker.perform
      expect(task.reload.status).to eql('finished')
    end

    it 'should rm docker container if finish' do
      run_docker_rm = false
      mock_cmd('docker rm') do |cmd|
        run_docker_rm = true
        expect(cmd.split.last).to eq('container_id')
      end

      code_worker.perform
      expect(run_docker_rm).to eql(true)
    end
  end
end


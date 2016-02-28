RSpec.describe StartTaskWorker do
  let(:worker) { StartTaskWorker.new }
  let(:schedule) { create_schedule('aa', user: fetch_user('a')) }

  describe '#perform' do
    let(:cw) { double(perform: true) }

    before :each do
      allow(CodeWorker).to receive(:new).with(kind_of(Task)).and_return(cw)
    end

    it 'should create task' do
      expect {
        worker.perform(schedule.id)
      }.to change(Task, :count).by(1)

      task = Task.last
      expect(task.schedule_id).to eq(schedule.id)
    end

    it 'should call code_worker#perform' do
      expect(cw).to receive(:perform)
      worker.perform(schedule.id)
    end

    it 'task.user should schedule user' do
      worker.perform(schedule.id)
      expect(Task.last.user).to eq(schedule.user)
    end
  end
end


RSpec.describe Schedule, type: :model do
  let(:schedule) { create_schedule('aa') }

  describe 'default value' do
    it 'active default eql true' do
      expect(Schedule.new.active).to eq(true)
    end
  end

  describe 'validates' do
    it 'name length should in 2..128' do
      schedule.name = '1'
      expect { schedule.name = '22' }.to change(schedule, :valid?).to(true)
      expect { schedule.name = '1' * 129 }.to change(schedule, :valid?).to(false)
    end

    it 'should not save invalid cron' do
      expect { schedule.cron = '* 123' }.to change(schedule, :valid?).to(false)
    end

    it 'should not save cron if interval < 10.minutes ' do
      schedule.cron = '123'
      expect(schedule.valid?).to eq(true)
      expect { schedule.cron = '* * * * *' }.to change(schedule, :valid?).to(false)
      expect { schedule.cron = '2016-1-1 0:0:0' }.to change(schedule, :valid?).to(true)
    end
  end

  describe 'schedule' do
    it 'should create sidekiq-cron job, after create' do
      expect {
        schedule
      }.to change { Sidekiq::Cron::Job.count }.by(1)

      job = Sidekiq::Cron::Job.all.first
      expect(job.name).to eq(schedule.cron_id)
      expect(job.cron).to eq(schedule.cron)
      expect(job.klass).to eq('StartTaskWorker')
      expect(job.args).to eq([schedule.id])
    end

    it 'should update sidekiq-cron job, after update' do
      schedule

      expect {
        schedule.update(cron: '20 * * * *')
      }.to change { Sidekiq::Cron::Job.count }.by(0)

      job = Sidekiq::Cron::Job.all.first
      expect(job.name).to eq(schedule.cron_id)
      expect(job.cron).to eq(schedule.cron)
      expect(job.klass).to eq('StartTaskWorker')
      expect(job.args).to eq([schedule.id])
    end

    it 'should destroy sidekiq-cron job, after destroy' do
      schedule

      expect {
        schedule.destroy
      }.to change { Sidekiq::Cron::Job.count }.by(-1)
    end
  end
end

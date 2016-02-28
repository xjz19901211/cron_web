class StartTaskWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(schedule_id)
    schedule = Schedule.find(schedule_id)
    task = schedule.work.tasks.create!(schedule_id: schedule.id, user_id: schedule.user_id)
    CodeWorker.new(task).perform
  end
end


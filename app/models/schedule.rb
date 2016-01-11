class Schedule < ActiveRecord::Base
  validates :name, presence: true, length: {in: 2..128}
  validate :cron_validator

  belongs_to :work
  has_many :tasks

  after_commit :create_cron_job, on: :create
  after_commit :update_cron_job, on: :update
  after_commit :destroy_cron_job, on: :destroy


  def initialize(attrs = {})
    super(attrs)
    self.active ||= true
  end

  def cron_id
    "cron_schedule_#{id}"
  end


  private

  def cron_validator
    parsed_cron = Rufus::Scheduler.parse(cron) rescue nil

    unless parsed_cron
      errors.add(:cron, "Couldn't parse '#{cron}'")
      return
    end
    return unless parsed_cron.is_a?(Rufus::Scheduler::CronLine)
    min_interval = Settings.base['min_cron_interval']

    if parsed_cron.frequency < min_interval
      errors.add(:cron, "Interval cannot less #{min_interval} seconds")
    end
  end

  def create_cron_job
    Sidekiq::Cron::Job.create({
      name: cron_id,
      cron: cron,
      class: 'StartTaskWorker',
      args: [id]
    })
  end

  def update_cron_job
    job = Sidekiq::Cron::Job.find(cron_id)
    job.cron = cron
    job.save
  end

  def destroy_cron_job
    Sidekiq::Cron::Job.destroy(cron_id)
  end
end

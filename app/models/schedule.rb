class Schedule < ActiveRecord::Base
  acts_as_paranoid

  validates :name, presence: true, length: {in: 2..128}
  validate :cron_validator

  belongs_to :user
  belongs_to :work
  has_many :tasks

  after_commit :create_cron_job, on: :create
  after_commit :update_cron_job, on: :update
  after_destroy :destroy_cron_job


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
    return if deleted?

    Sidekiq::Cron::Job.create({
      name: cron_id,
      cron: cron,
      class: 'StartTaskWorker',
      args: [id]
    })
  end

  def update_cron_job
    return if deleted?

    job = Sidekiq::Cron::Job.find(cron_id)
    if job
      job.cron = cron
      job.save
    else
      Sidekiq::Cron::Job.create({
        name: cron_id,
        cron: cron,
        class: 'StartTaskWorker',
        args: [id]
      })
    end
  end

  def destroy_cron_job
    Sidekiq::Cron::Job.destroy(cron_id)
  end
end

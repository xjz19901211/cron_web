class Schedule < ActiveRecord::Base
  validates :name, presence: true, length: {in: 2..128}

  belongs_to :work
  has_many :tasks

  validate :cron_validator

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
end

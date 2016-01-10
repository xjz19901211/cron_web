class Schedule < ActiveRecord::Base
  validates :name, presence: true, length: {in: 2..128}

  belongs_to :work
  has_many :tasks

  def initialize(attrs = {})
    super(attrs)
    self.active ||= true
  end
end

class User < ActiveRecord::Base
  include BCrypt

  ALL_ROLES = %w{normal admin}

  attr_accessor :password_length

  VALID_EMAIL_REGEXP = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :email, presence: true, uniqueness: true, format: VALID_EMAIL_REGEXP
  validates :role, presence: true, inclusion: {in: ALL_ROLES}
  validate :password_length_validator

  def initialize(attrs = {})
    super(attrs)
    self.role ||= 'normal'
  end

  def password
    return unless password_hash
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_length = new_password.length
    self.password_hash = @password
  end

  def name
    email.split('@', 2).first
  end


  private

  def password_length_validator
    return true unless password_length
    errors.add(:password, "too short, requires >= 8") if password_length < 8
  end
end

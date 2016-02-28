class UserLog < ActiveRecord::Base
  serialize :params, JSON

  belongs_to :user
end

class UserLogsController < ApplicationController

  # GET /user_logs
  # GET /user_logs.json
  def index
    @user_logs = UserLog.all
  end
end


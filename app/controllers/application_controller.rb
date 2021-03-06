class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :check_user_filter

  helper_method :current_user

  def current_user
    @current_user ||= User.where(id: session[:user_id]).first
  end

  def sign_in(user)
    session[:user_id] = user.id
    @current_user ||= user
  end

  def sign_out
    session.clear
    @current_user = nil
  end

  def create_action_user_log(log_params = {})
    create_user_log("#{action_name}-#{controller_name.singularize}", log_params)
  end

  def create_user_log(log_action, log_params)
    UserLog.create!(action: log_action, params: log_params, user: current_user)
  end


  private

  def check_user_filter
    redirect_to new_session_path unless current_user
  end
end

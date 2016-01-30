class SessionsController < ApplicationController
  skip_before_filter :check_user_filter

  def new
    if current_user
      redirect_to root_path
    else
      render 'new', layout: false
    end
  end

  def create
    user = User.find_by_email(params[:email])

    if user && user.password == params[:password]
      sign_in(user)
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end


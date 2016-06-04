class SessionsController < ApplicationController
  skip_before_action :logged_in?, only: [:new, :create]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by_credentials(params[:user][:username], params[:user][:password])

    if @user.nil?
      flash.now[:errors] = ["Incorrect login credentials"]
      render :new
    else
      login_user!(@user)
      redirect_to subs_url
    end
  end

  def destroy
    logout_user!
    redirect_to login_url
  end

  private
end

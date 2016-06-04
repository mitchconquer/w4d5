class UsersController < ApplicationController
  skip_before_action :logged_in?, only: [:new, :create]
  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login_user!(@user)
      redirect_to subs_url
    else
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end

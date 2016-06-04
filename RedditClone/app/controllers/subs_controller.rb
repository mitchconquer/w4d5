class SubsController < ApplicationController
  before_action :verify_moderator, only: [:edit, :update]

  def new
    @sub = Sub.new
  end

  def create
    @sub = Sub.new(sub_params)
    @sub.user_id = current_user.id

    if @sub.save
      redirect_to sub_url(@sub)
    else
      render :new
    end
  end

  def edit
    @sub = Sub.find(params[:id])
  end

  def update
    @sub = Sub.find(params[:id])
    if @sub.update_attributes(sub_params)
      redirect_to sub_url(@sub)
    else
      render :edit
    end
  end

  def index
    @subs = Sub.all.includes(:posts)
  end

  def show
    @sub = Sub.find(params[:id])
  end

  def destroy
  end

  private
  def verify_moderator
    @sub = Sub.find(params[:id]).user_id
    unless @sub.user_id == current_user.id
      flash[:errors] = ["You don't have access to modify this sub"]
      redirect_to sub_url(@sub)
    end
  end

  def sub_params
    params.require(:sub).permit(:title, :description, :user_id)
  end
end

class CommentsController < ApplicationController
  before_action :verify_creator, only: [:edit, :update, :destroy]

  def new
    @comment = Comment.new
  end

  def create
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = params[:post_id]
    # fail
    if @comment.save
      redirect_to post_url(@comment.post_id)
    else
      flash[:errors] = @comment.errors.full_messages
      redirect_to post_url(params[:post_id])
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      redirect_to post_url(@comment.post_id)
    else
      render :edit
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to post_url(@comment.post_id)
  end

  private
  def comment_params
    params.require(:comment).permit(:content, :parent_comment_id)
  end

  def verify_creator
    unless Comment.find(params[:id]).user_id == current_user.id
      flash[:errors] = ["You don't have access to modify this comment"]
      redirect_to post_url(@comment.post_id)
    end
  end
end

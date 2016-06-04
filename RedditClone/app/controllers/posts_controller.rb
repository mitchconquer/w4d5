class PostsController < ApplicationController
  before_action :verify_creator, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    @post.sub_id = params[:sub_id]

    if @post.save
      redirect_to post_url(@post)
    else
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(post_params)
      redirect_to post_url(@post)
    else
      render :edit
    end
  end

  def show
    @post = Post.find(params[:id])
    @all_comments = Comment.all.includes(:author).where(post_id: params[:id])
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to sub_url(@post.sub_id)
  end

  private
  def post_params
    params.require(:post).permit(:title, :url, :content)
  end

  def verify_creator
    unless Post.find(params[:id]).user_id == current_user.id
      flash[:errors] = ["You don't have access to modify this post"]
      redirect_to sub_url(@post.sub_id)
    end
  end
end

class PostsController < ApplicationController

  before_action :authenticate_user, {only:[:show, :new, :create, :edit, :update, :destroy]}

  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}

  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @post.user_id != @current_user.id
      flash[:notice] = "You do not have permission"
      redirect_to("/posts/index")
    end
  end

  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def show
    @post = Post.find_by(id: params[:id])
    @user = @post.user
    @likes_count = Like.where(post_id: @post.id).count
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(content: params[:content], user_id: @current_user.id)
    if @post.save
      flash[:notice] = "Post created"
      redirect_to("/posts/index")
    else
      @error_message = "Can't post blank or more than 140 characters"
      render("posts/new")
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
  end

  def update
    @post = Post.find_by(id: params[:id])
    @post.content = params[:content]
    if @post.save
      flash[:notice] = "Post edited"
      redirect_to("/posts/index")
    else
      @error_message = "Can't post blank or more than 140 characters"
      render("posts/edit")
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    flash[:notice] = "Post deleted"
    redirect_to("/posts/index")
  end

end

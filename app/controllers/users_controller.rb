class UsersController < ApplicationController


  before_action :authenticate_user, {only:[:index, :show, :edit, :update]}

  before_action :forbid_login_user, {only:[:new, :create, :login_form, :login]}

  before_action :ensure_correct_user, {only: [:edit, :update]}

  def likes
    @user = User.find_by(id: params[:id])
    @likes = Like.where(user_id: @user.id)
  end

  def ensure_correct_user
    if @current_user.id != params[:id].to_i
      flash[:notice] = "You do not have permission"
      redirect_to("/posts/index")
    end
  end

  def index
    @users = User.all
  end


  def show
    @id = params[:id]
    @user = User.find_by(id: params[:id])
  end


  def new
    @user = User.new
  end


  def create
    @user = User.new(name:params[:name], email:params[:email], password:params[:password], image_name: "default_user.jpeg")
    @user.save
    if @user.save
      session[:user_id] = @user.id
      redirect_to("/users/#{@user.id}")
      flash[:notice] = "Signed in"
    else
      @error_message = "UserName and email are required"
      render("/users/new")
    end
  end


  def edit
    @user = User.find_by(id: params[:id])
  end



  def update
    @user = User.find_by(id:params[:id])
    @user.name = params[:name]
    @user.email = params[:email]
    if params[:image]
      @user.image_name = "#{@user.id}.jpg"
      image = params[:image]
      File.binwrite("public/user_images/#{@user.image_name}", image.read)
    end
    @user.save
    if @user.save
      flash[:notice] = "Profile edited"
      redirect_to("/users/#{@user.id}")
    else
      @error_message = "UserName and email are required"

      render("/users/edit")
    end
  end


  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "Logged in"
      redirect_to("/posts/index")
    else
      @error_message = "Incorrect email or password"
      @email = params[:email]
      @password = params[:password]
      render("/users/login_form")
    end
  end


  def logout
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to("/login")
  end

end

class UsersController < ApplicationController
  
  before_action :authenticate_user, {only: [ :show, :edit, :update]}
  before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}
  before_action :ensure_correct_user, {only: [:edit,:update]}


  def index
    @user = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(name: params[:name],password: params[:password],career: params[:career],image_name: "defo.jpg")
    
    if @user.save 
      session[:user_id] = @user.id
      flash[:notice] ="ユーザー登録できました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/new")
      
    end
  end

  def add
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])

    @user.name = params[:name]
    @user.password = params[:password]
    @user.career = params[:career]
    

    if params[:image]
      @user.image_name = "#{@user.id}.jpg"
      image = params[:image]
      File
      File.binwrite("public/user_images/#{@user.image_name}", image.read) 
    end

    if @user.save
      redirect_to("/users/#{@user.id}")
       flash[:notice]="ユーザー情報を編集しました"
    else
      render("users/edit")
    end
  end

  def destroy

    @user = User.find_by(id: params[:id])
    @user.destroy

    flash[:notice] = "ユーザーを削除しました"
    redirect_to("/login")

  end

  def login_form

  end

  def login
    @user = User.find_by(name: params[:name])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] ="ログインしました"
      redirect_to("/posts")
    else
      @error_message="名前またはパスワードが間違っています"
      @email = params[:name]
      @password = params[:password]

      render("users/login_form")
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] ="ログアウトしました"
    redirect_to("/login")
  end

  def ensure_correct_user
    if @current_user.id != params[:id].to_i
      flash[:notice] = "権限がありません"
      redirect_to("/posts")
    end
  end

def likes
  @user = User.find_by(id: params[:id])
  @likes = Like.where(user_id: @user.id)
end
end

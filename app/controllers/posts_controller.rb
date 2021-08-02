class PostsController < ApplicationController
  
  before_action :authenticate_user, {only: [:show, :edit, :update]}
  before_action :ensure_correct_user, {only: [:edit, :update,:destroy]}


  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(content: params[:content],user_id: @current_user.id)

    if @post.save
      flash[:notice] = "新規投稿をしました"
      redirect_to("/posts")      
    else
      render("posts/new")
    end
  end

  def show
    @post = Post.find_by(id: params[:id])
    @user = @post.user
    @likes_count = Like.where(post_id: @post.id).count
  end

  def edit
    @post = Post.find_by(id: params[:id])
  end

  def add
  end

  def update
    @post = Post.find_by(id: params[:id])
    @post.content = params[:content]
    

    if @post.save
      flash[:notice] = "投稿を投稿しました"
    redirect_to("/posts")
    else
    render("/posts/edit")
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to("/posts")
  end

  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @post.user_id != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to("/posts")
    end
  end


end

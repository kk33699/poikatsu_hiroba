class PostsController < ApplicationController
  before_action :authenticate_user! # ログインを必須
  before_action :set_post, only: %i[show edit update destroy]
  before_action :ensure_guest_user, only: %i[edit update destroy]

  def index
    @posts = Post.all
  
    # キーワード検索
    if params[:query].present?
      keyword = "%#{params[:query]}%"
      @posts = @posts.where("title LIKE ? OR body LIKE ?", keyword, keyword)
    end
  
    # ポイント還元率検索
    if params[:reward_rate].present?
      @posts = @posts.where(reward_rate: params[:reward_rate])
    end
  
    # タグ検索
    if params[:tag].present?
      @posts = @posts.tagged_with(params[:tag])
    end
  end

  def show
    @post = Post.find(params[:id]) 
    @comment = Comment.new 
    @comments = @post.comments.includes(:user)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params) # ログイン中のユーザーに紐付け

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "投稿が完了されました" }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params) # レビュー
        format.html { redirect_to @post, notice: "投稿が編集されました" }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to mypage_users_path, status: :see_other, notice: "投稿が削除されました。" }
      format.json { head :no_content }
    end
  end

  private

  # タグを許可
  def post_params
    params.require(:post).permit(:title, :body, :reward_rate, :rate, :tag_list) 
  end

  def set_post
    @post = Post.find(params[:id]) 
  rescue ActiveRecord::RecordNotFound
    redirect_to posts_path, alert: 'その投稿は存在しません。'
  end

  # ゲストユーザーの制限
  def ensure_guest_user
    if current_user.email == 'guest@example.com'
      redirect_to root_path, alert: 'ゲストユーザーはこの操作を行えません。'
    end
  end
end

class PostsController < ApplicationController
  before_action :authenticate_user! # ログインを必須にする
  before_action :set_post, only: %i[show edit update destroy]
  before_action :ensure_guest_user, only: %i[edit update destroy]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # POST /posts or /posts.json
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

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "投稿が編集されました" }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to mypage_users_path, status: :see_other, notice: "投稿が削除されました。" }
      format.json { head :no_content }
    end
  end
  

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find_by(id: params[:id]) # 全ての投稿を対象に検索
    if @post.nil? || @post.user != current_user
      redirect_to posts_path, alert: "アクセス権がありません。"
    end
  end

  # ゲストユーザーの制限
  def ensure_guest_user
    if current_user.email == 'guest@example.com'
      redirect_to root_path, alert: 'ゲストユーザーはこの操作を行えません。'
    end
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :body) # :user_idは不要
  end
end


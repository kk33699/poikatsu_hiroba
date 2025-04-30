class PostsController < ApplicationController
  before_action :authenticate_user! # すべてのユーザーがログイン必須
  before_action :set_post, only: %i[show edit update destroy]
  before_action :ensure_guest_user, only: %i[new create edit update destroy]
  before_action :ensure_correct_user, only: %i[edit update]  # ログインユーザー以外のIDで投稿編集URLにアクセス制限

  def edit
  end

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

    # ソート機能
    case params[:sort_by]
    when 'likes' # いいね
      @posts = @posts.left_joins(:favorites)
                     .group("posts.id")
                     .order(Arel.sql('COUNT(favorites.id) DESC'))
    when 'rating' #評価ソート機能
      @posts = @posts.order(rate: :desc)
    when 'comments' # コメント数ソート機能
      @posts = @posts.left_joins(:comments)
                     .group("posts.id")
                     .order(Arel.sql('COUNT(comments.id) DESC'))
    # when 'likes_comments_rating' いいね+コメント数+評価ソート機能（順番もその通り） 後日使用する可能性があるためコメントアウト
      # @posts = @posts.left_joins(:favorites, :comments) 後日使用する可能性があるためコメントアウト
                     # .group("posts.id") 後日使用する可能性があるためコメントアウト
                     # .order(Arel.sql('COUNT(favorites.id) DESC, COUNT(comments.id) DESC, COALESCE(rate, 0) DESC')) 後日使用する可能性があるためコメントアウト
    else
      @posts = @posts.includes(:favorites, :comments).order(created_at: :desc) # 新着順表示＆いいね・コメント事前読み込み
    end
  end

  def show
    @post = Post.includes(:user, :comments).find(params[:id]) 
    @comment = Comment.new 
    @comments = @post.comments.includes(:user).order(created_at: :desc)
    @previous_post = Post.where("id < ?", @post.id).order(id: :desc).first # 「← 前の投稿」
    @next_post = Post.where("id > ?", @post.id).order(id: :asc).first # 「次の投稿 →」
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

  # ログインユーザー以外のIDで投稿編集URLにアクセス制限
  def ensure_correct_user
    unless @post.user == current_user
      redirect_to posts_path, alert: '他のユーザーの投稿は編集できません。'
    end
  end
end
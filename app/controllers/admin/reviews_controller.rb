class Admin::ReviewsController < ApplicationController
  layout 'admin' # 管理者レイアウト
  before_action :authenticate_admin! # 管理者認証
  before_action :set_review, only: [:destroy]

  def index
    @reviews = Post.includes(:user).order(created_at: :desc) # 新着順

    # 投稿検索
    if params[:query].present?
      keyword = "%#{params[:query]}%"
      @reviews = @reviews.where("title LIKE ? OR body LIKE ?", keyword, keyword)
    end
  end

  def destroy
    @review.destroy
    redirect_to admin_reviews_path, notice: "レビューを削除しました。"
  end

  private

  def set_review
    @review = Post.find(params[:id])
  end
end

class Admin::ReviewsController < ApplicationController
  layout 'admin' # 管理者レイアウト
  before_action :authenticate_admin! # 管理者認証
  before_action :set_review, only: [:destroy]

  def index
    @reviews = Post.all # レビューをすべて取得
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

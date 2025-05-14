class Admin::PostsController < ApplicationController
  layout 'admin' # 管理者用レイアウト
  before_action :authenticate_admin! # 管理者認証
  before_action :set_post, only: [:show, :destroy] # 投稿データを取得

  def show 
    @post = Post.find(params[:id])
  end
  def destroy
    @post.destroy
    redirect_to admin_reviews_path, notice: "投稿を削除しました。"
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end
end

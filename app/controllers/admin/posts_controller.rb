class Admin::PostsController < ApplicationController
  layout 'admin' # 管理者用レイアウト
  before_action :authenticate_admin! # 管理者認証
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def show 
    @post = Post.find(params[:id])
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to admin_post_path(@post), notice: "投稿が編集されました。"
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to admin_reviews_path, notice: "投稿を削除しました。"
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :reward_rate, :rate, :tag_list)
  end

end

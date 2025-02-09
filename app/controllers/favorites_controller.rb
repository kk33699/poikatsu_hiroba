class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.new(post_id: @post.id)

    if favorite.save
      redirect_to @post, notice: '「いいね」をしました。'
    else
      redirect_to @post, alert: '「いいね」の追加に失敗しました。'
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: @post.id)

    if favorite.destroy
      redirect_to @post, notice: '「いいね」を解除しました。'
    else
      redirect_to @post, alert: '「いいね」の解除に失敗しました。'
    end
  end
end

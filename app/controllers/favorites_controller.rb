class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.new(post_id: @post.id)
  
    if favorite.save
      redirect_to request.referer || posts_path, notice: '「いいね」をしました。'
    else
      redirect_to request.referer || posts_path, alert: '「いいね」の追加に失敗しました。'
    end
  end
  
  def destroy
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: @post.id)
  
    if favorite.destroy
      redirect_to request.referer || posts_path, notice: '「いいね」を解除しました。'
    else
      redirect_to request.referer || posts_path, alert: '「いいね」の解除に失敗しました。'
    end
  end
  
end

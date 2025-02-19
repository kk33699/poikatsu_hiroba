class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    post = Post.find(params[:post_id])
    favorite = current_user.favorites.new(post_id: post.id)
    favorite.save
    redirect_to request.referer || posts_path, allow_other_host: true
  end

  def destroy
    post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: post.id)
    favorite&.destroy
    redirect_to request.referer || posts_path, allow_other_host: true
  end
end

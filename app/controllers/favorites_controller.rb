class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :restrict_guest_user
  
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

  private

  def restrict_guest_user
    if current_user.email == 'guest@example.com'
      redirect_to root_path, alert: 'ゲストユーザーは「いいね」機能を利用できません。'
    end
  end

end

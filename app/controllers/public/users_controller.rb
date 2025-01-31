class Public::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @post_images = @user.posts
  end
end

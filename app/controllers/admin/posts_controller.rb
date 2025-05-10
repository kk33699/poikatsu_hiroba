class Admin::PostsController < ApplicationController
  layout 'admin' # 管理者用レイアウト
  before_action :authenticate_admin! # 管理者認証

  def show 
    @post = Post.find(params[:id])
  end
end
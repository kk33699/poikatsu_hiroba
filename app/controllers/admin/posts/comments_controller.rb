# 管理者用コメント削除一旦コメントアウト
# class Admin::Posts::CommentsController < ApplicationController
  # before_action :authenticate_admin!
  # before_action :set_post
  # before_action :set_comment

  # def destroy
    # @comment.destroy
    # redirect_to admin_post_path(@post), notice: 'コメントを削除しました。'
  # end

  # private

  # def set_post
    # @post = Post.find(params[:post_id])
  # end

  # def set_comment
    # @comment = Comment.find(params[:id])
  # end
# end
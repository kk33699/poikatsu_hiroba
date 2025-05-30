class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:guest_login]
  before_action :set_user, only: %i[show edit update destroy destroy_account]

  # マイページ
  def mypage
    @user = current_user
    @posts = @user.posts # ログイン中のユーザーの投稿を取得
  end

  # ユーザー詳細
  def show
    @posts = @user.posts
  end

  # マイプロフィール編集
  def edit
  end

  # ユーザー編集処理
  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'プロフィールが更新されました。'
    else
      render :edit
    end
  end

  # ユーザー退会処理
  def destroy_account
    if @user == current_user
      @user.destroy
      redirect_to new_user_registration_path, notice: '退会が完了しました。'
    else
      redirect_to root_path, alert: '退会に失敗しました。'
    end
  end

  # ユーザー検索機能
  def search
    if params[:query].present?
      @users = User.where("name LIKE ?", "%#{params[:query]}%")
                   .where.not(email: "guest@example.com") # ゲストユーザー除外
    else
      @users = User.where.not(email: "guest@example.com") # 検索していない場合ゲストユーザー除外
    end
  end


  # ゲストログイン処理
  def guest_login
    user = User.find_or_create_by!(email: 'guest@example.com') do |guest|
      guest.name = 'ゲストユーザー'
      guest.password = SecureRandom.urlsafe_base64
    end
    sign_in user
    redirect_to posts_path, notice: 'ゲストユーザーとしてログインしました。'
  end

  private

  def set_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to mypage_users_path, alert: 'アクセス権がありません。'
    end
  end

  #プロフィール編集
  def user_params
    params.require(:user).permit(:name, :email, :avatar)
  end
end

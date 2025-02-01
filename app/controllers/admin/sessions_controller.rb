class Admin::SessionsController < Devise::SessionsController
  layout 'admin'

  protected

   # ログイン後はダッシュボードへ
  def after_sign_in_path_for(resource)
    admin_users_path
  end

  # ログアウト後はログイン画面へ
  def after_sign_out_path_for(resource_or_scope)
    new_admin_session_path
  end
end
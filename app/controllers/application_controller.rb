class ApplicationController < ActionController::Base
  before_action :configure_authentication
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_authentication
    if admin_controller?
      authenticate_admin! # 管理者の認証
    else
      authenticate_user! unless action_is_public? # エンドユーザーの認証
    end
  end

  def admin_controller?
    self.class.module_parent_name == 'Admin'
  end

  def action_is_public?
    controller_name == 'homes' && action_name.in?(%w[top about])
  end

  # ログイン後の遷移先
  def after_sign_in_path_for(resource)
    if resource.is_a?(Admin)
      admin_dashboards_path # 管理者ログイン後
    else
      mypage_users_path # 一般ユーザーログイン後
    end
  end

  # ログアウト後の遷移先
  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope == :admin
      new_admin_session_path # 管理者ログアウト後
    else
      about_path # 一般ユーザーログアウト後
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end

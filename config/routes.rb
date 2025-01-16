Rails.application.routes.draw do
  resources :posts
  devise_for :users
  root to: 'homes#top'
  get 'about', to: 'homes#about'

  
  resources :users, only: [:show, :edit, :update] do
    member do
      delete :destroy_account # ユーザー退会処理
    end
    collection do
      get :mypage # マイページ
    end
  end

  post 'guest_login', to: 'users#guest_login'  # ゲストログイン用のルート
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

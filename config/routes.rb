Rails.application.routes.draw do
  resources :posts
  devise_for :users
  root to: 'homes#top'
  get 'about', to: 'homes#about'

  resources :posts do
    collection do
      get :search # 投稿検索機能
    end
    resources :comments, only: [:create, :destroy] # コメント機能
  end
  
  resources :users, only: [:show, :edit, :update] do
    member do
      delete :destroy_account # ユーザー退会処理
    end
    collection do
      get :mypage # マイページ
      get :search # ユーザー検索機能
    end
  end

  post 'guest_login', to: 'users#guest_login'  # ゲストログイン
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

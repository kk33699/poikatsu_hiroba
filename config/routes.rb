Rails.application.routes.draw do
  resources :posts
  devise_for :users
  root to: 'homes#top'
  get 'about', to: 'homes#about'

  # ユーザー関連
  resources :users, only: [:show, :edit, :update] do
    member do
      delete :destroy_account # ユーザー退会処理
    end
    collection do
      get :mypage # マイページ
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

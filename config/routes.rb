Rails.application.routes.draw do
  resources :posts
  devise_for :users
  root to: 'homes#top'
  get 'about', to: 'homes#about'

  # 管理者ログイン
  devise_for :admin, skip: [:registrations, :password], controllers: {
    sessions: 'admin/sessions'
  }


  # 管理者管理
  namespace :admin do
    # get 'dashboards', to: 'dashboards#index' この部分不要
    get 'users', to: 'users#index'
    resources :users, only: [:index, :show, :destroy]
    resources :reviews, only: [:index, :destroy] # レビュー管理者
    resources :posts, only: [:show, :destroy] do # 管理者用：投稿詳細ページ＆削除
      resources :comments, only: [:destroy], module: :posts # 管理者用コメント削除
    end
  end

  # エンドユーザーの管理
  namespace :public do
    resources :users, only: [:show]
  end


  resources :posts do
    collection do
      get :search # 投稿検索機能
      get :tagged, to: 'posts#index', as: :tagged # タグ検索
    end

    resource :favorite, only: [:create, :destroy] # いいね機能
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
end


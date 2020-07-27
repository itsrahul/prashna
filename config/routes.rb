Rails.application.routes.draw do
  get 'credit_transactions/', to: 'credit_transactions#index', as: 'credit_transactions'
  get 'abuse_reports/:abusable/:id', to: 'abuse_reports#new', as: 'report_abuse'
  post 'abuse_reports/:abusable/:id', to: 'abuse_reports#create'
  get 'votes/create'
  get 'comments/create'
  get 'answers/create'
  get 'home/refresh'
  get 'notifications/index'
  get 'notifications/open', to: 'notifications#open', as: 'opens_notification'
  root 'home#index',  as: 'home_index'
  get 'search', to: "search#search"
  get 'search/topics/:name', to: "search#topics", as: 'search_topic'
  get 'search/user/:id', to: "search#user", as: 'search_user'
  post 'questions/:id', to: "questions#update"
  post 'users/:id', to: "users#update"
  # get 'user/:id/follow', to: "followers#create", as: 'follow_user'

  resources :questions do
    get 'user_followers', to: "questions#follower", as: 'follower', on: :collection
    resources :comments, only: :create
    resources :answers, only: :create
  end

  resources :answers, only: :create do
    resources :comments, only: :create
    resources :votes, only: [:create, :index]
  end

  resources :comments, only: :create do
    resources :votes, only: [:create, :index]
  end

  get 'topics', to: "topics#search"

  get 'topics/edit'
  root 'users#index'

  get 'password_resets/new'
  post 'password_resets/create'

  mount LetterOpenerWeb::Engine, at: "/letter_opener" #if Rails.env.development?

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'

  controller :users do
    get 'signup' => :new
    get 'profile' => :show
  end

  resources :users do
    collection do
      # get 'follower_questions', to: "questions#follower"
      post 'follows/:id', to: "followers#create", as: 'follows'
      post 'follows/fetch/:id', to: "followers#index", as: 'fetch_follows'
      get 'verify/:token', action: :verify, as: 'verification'
      get 'password_resets/:token', to: "password_resets#edit", as: 'send_token'
      post 'password_resets/:token', to: "password_resets#update", as: 'change_password'
    end
  end

  #FIXME_AB: /admin should redirect to admin/home
  get 'admin/home', to: "admin#index", as: 'admin'
  namespace :admin do
    resources :users, only: [:index, :show]
    resources :questions, only: [:index, :show, :edit] do
      resources :answers, only: :index
      resources :comments, only: :index
    end
    resources :answers, only: [:index, :show] do
      resources :comments, only: :index
    end
    resources :comments, only: [:index]
    post 'disable/user/:id', to: "users#disable", as: 'disable_user'
    post 'enable/user/:id', to: "users#enable", as: 'enable_user'
    # post 'unpublish/question/:id', to: "questions#unpublish", as: 'unpublish_question'
    post 'unpublish/answer/:id', to: "answers#unpublish", as: 'unpublish_answer'
    post 'unpublish/comment/:id', to: "comments#unpublish", as: 'unpublish_comment'

  end

  namespace :api do
    resources :topics, only: :show
    resources :feed, only: :index
    # get 'feed', to: "feed#index"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

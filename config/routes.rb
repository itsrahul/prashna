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

  # resources :search do
  #   collection do
      # get 'topics/:name', to: "search", as: 'topic'
      # get 'term/:term', action: :term, as: 'term'
      # get 'users/:id', action: :verify, as: 'user'
    # end
  # end
  resources :questions do
    resources :comments, only: :create
    resources :answers, only: :create
  end
  
  resources :answers, only: :create do
    resources :comments, only: :create
    resources :votes, only: :create
  end

  resources :comments, only: :create do
    resources :votes, only: :create
  end

  get 'topics', to: "topics#search"
  
  get 'topics/edit'
  # get 'topics/:name', to: "topics#index", as: 'topic'
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
      get 'verify/:token', action: :verify, as: 'verification'
      get 'password_resets/:token', to: "password_resets#edit", as: 'send_token'
      post 'password_resets/:token', to: "password_resets#update", as: 'change_password'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

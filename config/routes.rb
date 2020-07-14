Rails.application.routes.draw do
  get 'votes/create'
  get 'comments/create'
  get 'answers/create'
  get 'notifications/index'
  root 'home#index',  as: 'home_index'
  get 'search_questions/search'
  get 'search_questions/filter'

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
  get 'topics/index'
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

Rails.application.routes.draw do
  root 'home#index',  as: 'home_index'
  resources :questions do
    get :search, on: :collection
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

  resources :users do
    collection do
      get 'verify/:token', action: :verify, as: 'verification'
      get 'password_resets/:token', to: "password_resets#edit", as: 'send_token'
      post 'password_resets/:token', to: "password_resets#update", as: 'change_password'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

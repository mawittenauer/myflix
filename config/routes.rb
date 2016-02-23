Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  
  root 'static_pages#front_page'
  
  get '/home', to: 'videos#index'
  
  resources :videos, only: :show do
    collection do
      get :search, to: 'videos#search'
    end
    
    resources :reviews, only: [:create]
  end
  
  get '/register', to: 'users#new'
  
  get '/sign_in', to: 'sessions#new'
  
  post '/sign_in', to: 'sessions#create'
  
  get '/sign_out', to: 'sessions#destroy'
  
  get '/my_queue', to: 'queue_items#index'
  
  resources :users, only: [:create, :show]
  
  resources :queue_items, only: [:create, :destroy]
  
  post '/update_queue', to: 'queue_items#update_queue'
  
  resources :categories, only: :show
  
  get '/people', to: 'relationships#index'
  
  resources :relationships, only: [:destroy, :create]
  
  get '/forgot_password', to: 'forgot_passwords#new'
  resources :forgot_passwords, only: [:create]
  get '/forgot_password_confirmation', to: 'forgot_passwords#confirmation'
  
  resources :password_resets, only: [:show, :create]
  get '/expired_token', to: 'password_resets#expired_token'
end

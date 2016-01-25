Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  
  root 'static_pages#front_page'
  
  get '/home', to: 'videos#index'
  
  resources :videos, only: :show do
    collection do
      get :search, to: 'videos#search'
    end
  end
  
  resources :categories, only: :show
end

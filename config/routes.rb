Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :merchants, only: [:show] do
    resources :dashboard, only: [:index], controller: "merchant/dashboard"
  end
  
  resources :admin, only: [:index]
  
  namespace :admin do
    #merchants
    resources :merchants, only: [:index]
  end
   
  namespace :admin do
    #invoices
      resources :invoices, only: [:index]
  end
end

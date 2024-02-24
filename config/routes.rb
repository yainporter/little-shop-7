Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # /merchants/:merchant_id/dashboard
  resources :merchants, only: [] do
    resources :dashboard, module: "merchant", only: [:index]
    resources :items, module: "merchant", only: [:index]
    resources :invoices, module: "merchant", only: [:index, :show]
  end

  resources :admin, only: [:index]

  namespace :admin do
    resources :merchants, only: [:index, :show, :edit, :update]
    resources :invoices, only: [:index, :show]
  end
end

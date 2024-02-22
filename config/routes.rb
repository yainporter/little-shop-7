Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get "/merchants/:merchant_id/dashboard", to: "merchant/dashboard#index", as: :merchant_dashboard_index
  get "/merchants/:merchant_id/items", to: "merchant/items#index", as: :merchant_items_index
  get "/merchants/:merchant_id/invoices", to: "merchant/invoices#index", as: :merchant_invoices_index


  resources :admin, only: [:index]

  namespace :admin do
    resources :merchants, only: [:index]
    resources :invoices, only: [:index, :show]
  end

  resources :merchants, only: [:show] do
    resources :dashboard, only: [:index], controller: "merchant/dashboard"
  end
end

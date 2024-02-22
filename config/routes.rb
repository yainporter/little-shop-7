Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get "/merchants/:merchant_id/dashboard", to: "merchant/dashboard#index", as: :merchant_dashboard_index
  get "/merchants/:merchant_id/items", to: "merchant/items#index", as: :merchant_items_index
  get "/merchants/:merchant_id/invoices", to: "merchant/invoices#index", as: :merchant_invoices_index


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

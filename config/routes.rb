Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get "/", to: "application#welcome"

  resources :merchants, only: [] do
    get "/dashboard", to: "dashboard#show"
    resources :items, module: "merchant", except: [:destroy], via: [:patch]
    resources :invoices, module: "merchant", only: [:index, :show]
    resources :invoice_items, module: "merchant", only: [:update], via: [:patch]
    resources :bulk_discounts, module: "merchant", except: [:update]
    patch "/bulk_discounts/:id", to: "merchant/bulk_discounts#update", as: :update_bulk_discount
  end

  resources :admin, only: [:index], controller: "admin_dashboard"

  namespace :admin do
    resources :merchants, except: [:destroy], via: [:patch]
    resources :invoices, only: [:index, :show, :update], via: [:patch]
  end
end

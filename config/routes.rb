Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get "/merchants/:merchant_id/dashboard", to: "merchant/dashboard#index", as: :merchant_dashboard_index
  get "/merchants/:merchant_id/items", to: "merchant/items#index", as: :merchant_items_index
  get "/merchants/:merchant_id/invoices", to: "merchant/invoices#index", as: :merchant_invoices_index
  # /merchants/:merchant_id/dashboard

  resources :admin, only: [:index]

  namespace :admin do
    resources :merchants, only: [:index, :show, :edit, :update]
    resources :invoices, only: [:index, :show]
  end

  resources :merchants, only: [:show] do
    resources :dashboard, only: [:index], controller: "merchant/dashboard"
  end
end

#                   Prefix Verb  URI Pattern                                                                                       Controller#Action
# merchant_dashboard_index GET   /merchants/:merchant_id/dashboard(.:format)                                                       merchant/dashboard#index
#     merchant_items_index GET   /merchants/:merchant_id/items(.:format)                                                           merchant/items#index
#  merchant_invoices_index GET   /merchants/:merchant_id/invoices(.:format)                                                        merchant/invoices#index
#              admin_index GET   /admin(.:format)                                                                                  admin#index
#          admin_merchants GET   /admin/merchants(.:format)                                                                        admin/merchants#index
#      edit_admin_merchant GET   /admin/merchants/:id/edit(.:format)                                                               admin/merchants#edit
#           admin_merchant GET   /admin/merchants/:id(.:format)                                                                    admin/merchants#show
#                          PATCH /admin/merchants/:id(.:format)                                                                    admin/merchants#update
#                          PUT   /admin/merchants/:id(.:format)                                                                    admin/merchants#update
#           admin_invoices GET   /admin/invoices(.:format)                                                                         admin/invoices#index
#            admin_invoice GET   /admin/invoices/:id(.:format)                                                                     admin/invoices#show

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # /merchants/:merchant_id/dashboard
  resources :merchants, only: [] do
    resources :dashboard, module: "merchant", only: [:index]
    resources :items, module: "merchant", except: [:destroy]
    resources :invoices, module: "merchant", only: [:index, :show]
    resources :invoice_items, module: "merchant", only: [:update]
  end

  resources :admin, only: [:index]

  namespace :admin do
    resources :merchants, except: [:destroy]
    resources :invoices, only: [:index, :show, :update]
  end
end

# Prefix Verb  URI Pattern                                                                                       Controller#Action
#           merchant_items GET   /merchants/:merchant_id/items(.:format)                                                           merchant/items#index
#                          POST  /merchants/:merchant_id/items(.:format)                                                           merchant/items#create
#        new_merchant_item GET   /merchants/:merchant_id/items/new(.:format)                                                       merchant/items#new
#       edit_merchant_item GET   /merchants/:merchant_id/items/:id/edit(.:format)                                                  merchant/items#edit
#            merchant_item GET   /merchants/:merchant_id/items/:id(.:format)                                                       merchant/items#show
#                          PATCH /merchants/:merchant_id/items/:id(.:format)                                                       merchant/items#update
#                          PUT   /merchants/:merchant_id/items/:id(.:format)                                                       merchant/items#update
#        merchant_invoices GET   /merchants/:merchant_id/invoices(.:format)                                                        merchant/invoices#index
#         merchant_invoice GET   /merchants/:merchant_id/invoices/:id(.:format)                                                    merchant/invoices#show
#    merchant_invoice_item PATCH /merchants/:merchant_id/invoice_items/:id(.:format)                                               merchant/invoice_items#update
#                          PUT   /merchants/:merchant_id/invoice_items/:id(.:format)                                               merchant/invoice_items#update
#              admin_index GET   /admin(.:format)                                                                                  admin#index
#          admin_merchants GET   /admin/merchants(.:format)                                                                        admin/merchants#index
#                          POST  /admin/merchants(.:format)                                                                        admin/merchants#create
#       new_admin_merchant GET   /admin/merchants/new(.:format)                                                                    admin/merchants#new
#      edit_admin_merchant GET   /admin/merchants/:id/edit(.:format)                                                               admin/merchants#edit
#           admin_merchant GET   /admin/merchants/:id(.:format)                                                                    admin/merchants#show
#                          PATCH /admin/merchants/:id(.:format)                                                                    admin/merchants#update
#                          PUT   /admin/merchants/:id(.:format)                                                                    admin/merchants#update
#           admin_invoices GET   /admin/invoices(.:format)                                                                         admin/invoices#index
#            admin_invoice GET   /admin/invoices/:id(.:format)                                                                     admin/invoices#show
#                          PATCH /admin/invoices/:id(.:format)                                                                     admin/invoices#update
#                          PUT   /admin/invoices/:id(.:format)                                                                     admin/invoices#update

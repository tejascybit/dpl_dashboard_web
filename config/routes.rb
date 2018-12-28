Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'welcome#index'
  get 'welcome/index'

  get 'welcome/production_data_product_wise'
  get 'welcome/getting_production_data'
  get 'welcome/getting_inbound_data'
  get 'welcome/getting_inventory_data'
  get 'welcome/getting_sales_data'
  get 'welcome/getting_api_data'
  get 'welcome/all_inventory'
  get 'welcome/get_current_week'

  get 'inventory/index'


  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :data_getter
      get 'homedata' => 'data_getter#homedata'
      get 'open_stock' => 'data_getter#open_stock'
      get 'index' => 'data_getter#index'
      get 'stock' => 'data_getter#get_stock_data_product_wise'
      match '/open_stock' => 'data_getter#create', via: :post
    end
  end
end

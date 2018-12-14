Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'dashboard#index'
  get 'dashboard/index'

  get 'production' => 'welcome#production'
  get 'sales' => 'welcome#sales'
  get 'inventory' => 'welcome#inventory'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'open_stock' => "data_getter#open_stock"
    #  get 'get_sales_data_product_wise' => "data_getter#get_sales_data_product_wise"
  #    get 'get_prodution_data_product_wise' => "data_getter#get_prodution_data_product_wise"

    end
  end

end

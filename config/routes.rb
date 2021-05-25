require 'sidekiq/web'

Rails.application.routes.draw do
  
  mount ShopifyApp::Engine, at: '/'
  mount Sidekiq::Web => "/sidekiq"
  
  get 'help/index'
  get 'reports/index'
  get 'reports/download'
  get 'variants/export_csv'
  get 'variants/import_csv', to: 'variants#import_csv', as: 'variants_import_csv'
  put '/variants', to: 'variants#update'
  resources :variants
  resources :shop_settings, :except => [:show]
  resources :emails, :except => [:show, :index, :edit, :update]
  post '/shopify/products/create', to: 'shopify/products/products#create'
  post '/shopify/products/update', to: 'shopify/products/products#update'
  post '/shopify/products/delete', to: 'shopify/products/products#delete'
  post '/shopify/delete', to: 'shopify/apps#delete'

  root :to => 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

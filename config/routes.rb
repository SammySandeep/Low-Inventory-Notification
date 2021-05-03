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
  post '/shopify/create', to: 'shopify/products#create'
  post '/shopify/update', to: 'shopify/products#update'
  post '/shopify/delete', to: 'shopify/products#delete'

  root :to => 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

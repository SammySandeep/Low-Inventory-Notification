require 'sidekiq/web'

Rails.application.routes.draw do
  
  mount ShopifyApp::Engine, at: '/'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])) &
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
  end
  mount Sidekiq::Web => "/sidekiq"
  
  get '/help/index'

  get '/reports/index'
  get '/reports/download', to: 'reports#download'

  get '/variants/export_csv'
  get '/variants/import_csv', to: 'variants#import_csv', as: 'variants_import_csv'
  post '/variants/update_csv_threshold', to: 'variants#update_csv_threshold'
  put '/variants/', to: 'variants#update'
  
  post '/shopify/products/create', to: 'shopify/products#create'
  post '/shopify/products/update', to: 'shopify/products#update'
  post '/shopify/products/delete', to: 'shopify/products#delete'
  
  post '/shopify/app/uninstalled', to: 'shopify/apps#uninstalled'

  resources :variants, :except => [:show, :edit]
  resources :shop_settings, :except => [:show, :edit]
  resources :emails, :except => [:show, :index, :edit, :update]

  root :to => 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

require 'sidekiq/web'

Rails.application.routes.draw do
  
  mount ShopifyApp::Engine, at: '/'
  mount Sidekiq::Web => "/sidekiq"
  
  get 'help/index'
  get 'reports/index'
  get 'reports/download_report'
  get 'variants/export_csv'
  get 'variants/import_csv', to: 'variants#import_csv', as: 'variants_import_csv'
  resources :variants
  resources :shop_settings, :except => [:destroy, :show]

  root :to => 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do
  get 'help/index'
  get 'reports/index'
  get 'reports/download_report'
  get 'variants/export_csv'

  resources :variants

  resources :shop_settings
  mount ShopifyApp::Engine, at: '/'
  root :to => 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

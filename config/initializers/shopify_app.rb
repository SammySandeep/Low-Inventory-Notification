ShopifyApp.configure do |config|
  config.application_name = "My Shopify App"
  config.api_key = ENV.fetch('SHOPIFY_API_KEY', '').presence || raise('Missing SHOPIFY_API_KEY')
  config.secret = ENV.fetch('SHOPIFY_API_SECRET', '').presence || raise('Missing SHOPIFY_API_SECRET')
  config.old_secret = ""
  config.scope = "read_products" # Consult this page for more scope options:
                                 # https://help.shopify.com/en/api/getting-started/authentication/oauth/scopes
  config.embedded_app = true
  config.after_authenticate_job = false
  config.api_version = "2021-01"
  config.shop_session_repository = 'Shop'
  config.webhooks = [
    { topic: 'products/create', address: "#{ENV['URL']}/shopify/products/create", format: 'json' },
    { topic: 'products/update', address: "#{ENV['URL']}/shopify/products/update", format: 'json' },
    { topic: 'products/delete', address: "#{ENV['URL']}/shopify/products/delete", format: 'json' },
    { topic: 'app/uninstalled', address: "#{ENV['URL']}/shopify/app/uninstalled", format: 'json' }
  ]
  config.allow_jwt_authentication = true
end

# ShopifyApp::Utils.fetch_known_api_versions                        # Uncomment to fetch known api versions from shopify servers on boot
# ShopifyAPI::ApiVersion.version_lookup_mode = :raise_on_unknown    # Uncomment to raise an error if attempting to use an api version that was not previously known

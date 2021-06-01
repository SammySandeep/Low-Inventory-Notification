# frozen_string_literal: true
class Shop < ActiveRecord::Base

  include ShopifyApp::ShopSessionStorage
  include ShopifyModule

  has_many :products
  has_many :variants
  has_many :reports

  has_one :shop_setting

  after_create :sync_products_and_variants

  def api_version
    ShopifyApp.configuration.api_version
  end

  def admin_email
    activate_session shop_id: self.id
    return ShopifyAPI::Shop.current.email
  end

  private 

  def sync_products_and_variants
    SyncProductsJob.perform_later(shop_id: self.id)
  end

end

# frozen_string_literal: true
class Shop < ActiveRecord::Base
  include ShopifyApp::ShopSessionStorage

  has_many :products, dependent: :destroy
  has_many :variants, dependent: :destroy
  has_many :reports, dependent: :destroy

  has_one :shop_setting, dependent: :destroy

  after_create :create_shop_setting, :sync_products_and_variants

  def api_version
    ShopifyApp.configuration.api_version
  end

  private 

  def sync_products_and_variants
    SyncProductsJob.perform_later(shop_id: self.id)
  end

  def create_shop_setting
      begin
        @shop_setting = ShopSetting.new
        @shop_setting.global_threshold = 0
        @shop_setting.alert_frequency = 0
        @shop_setting.shop_id = self.id

        if @shop_setting.save
          Rails.logger.info "shop setting for shop #{self.shopify_domain} successfully created"
        else
          Rails.logger.info "#{@shop_setting.errors.full_messages.join(", ")}"
        end

      rescue ActiveRecord::StatementInvalid => e 
          Rails.logger.info "#{e}"
      end
  end
  
end

class ShopSettingsController < ApplicationController
  layout 'application'
  before_action :set_shop_setting, only: [:edit, :update]
  
  def index
    if current_shop.shop_setting.present?
      @shop_setting = current_shop.shop_setting
      if !@shop_setting.emails.nil?
        @emails = @shop_setting.emails
      end
    else
      redirect_to new_shop_setting_path
    end
  end
  
  def new
    @shop_setting = ShopSetting.new
  end

  def create
    @shop_setting = ShopSetting.new(shop_setting_params)
    @shop_setting.shop_id = current_shop.id
    respond_to do |format|
      if @shop_setting.save
        format.html { redirect_to shop_settings_path }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @global_threshold = @shop_setting.global_threshold
    @email_params = shop_setting_params[:emails_attributes]
    if shop_setting_params[:emails_attributes].present?
      @email_to_update = Email.find(shop_setting_params[:emails_attributes][:id])
      @email_id_to_update_for_error = @email_to_update.email
      @email_id = shop_setting_params[:emails_attributes][:id]
      @email = shop_setting_params[:emails_attributes][:email]
      @is_active = shop_setting_params[:emails_attributes][:is_active]
    end
    @shop_setting.update!(shop_setting_params)
    respond_to do |format|
      format.js
    end
  end

  private

    def set_shop_setting
      @shop_setting = ShopSetting.find(params[:id])
    end

    def shop_setting_params
      params.require(:shop_setting).permit(:global_threshold, :alert_frequency, emails_attributes: Email.attribute_names.map(&:to_sym))
    end
    
end


class ShopSettingsController < ApplicationController
  layout 'application'
  before_action :set_shop_setting, only: [:show, :edit, :update]

  include ApplicationHelper

  def index
    @shop_setting = find_shop_by_shopify_domain(session['shopify.omniauth_params']['shop']).shop_setting
    @emails = @shop_setting.emails
  end

  def show
    @emails = @shop_setting.emails
  end


  def edit

  end

  def update
    respond_to do |format|
      if @shop_setting.update(shop_setting_params)
        format.html { redirect_to shop_settings_path, notice: 'Shop setting was successfully updated.' }
        format.json { render :show, status: :ok, location: @shop_setting }
      else
        format.html { render :edit }
        format.json { render json: @shop_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def set_shop_setting
      @shop_setting = ShopSetting.find(params[:id])
    end

    def shop_setting_params
      params.require(:shop_setting).permit(:global_threshold, :alert_frequency, emails_attributes: Email.attribute_names.map(&:to_sym).push(:_destroy))
    end
end


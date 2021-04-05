class VariantsController < ApplicationController
  include ApplicationHelper

  before_action :set_variant, except: [:index, :export_csv]
  
  def index
    @variants = find_shop_by_shopify_domain(session['shopify.omniauth_params']['shop']).variants.paginate(:page => params[:page], per_page: 50)
  end

  def show
  end

  def edit
  end

  def export_csv
    shop = find_shop_by_shopify_domain(session['shopify.omniauth_params']['shop'])
    ExportCsvJob.perform_later(shop, sql_statement(shop))
    respond_to do |format|
      format.html { redirect_to variants_path, notice: 'CSV Generation is in Queue, will send an email once done please be patient' }
    end
  end

  def update
    respond_to do |format|
      if @variant.update(variant_params)
        format.html { redirect_to @variant, notice: 'Variant was successfully updated.' }
        format.json { render :index, status: :ok, location: @variant }
      else
        format.html { render :edit }
        format.json { render json: @variant.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_variant
    @variant = Variant.find(params[:id])
  end

  def variant_params
    params.require(:variant).permit(:threshold)
  end

  def sql_statement shop
    "SELECT variants.shopify_variant_id AS id, products.title AS title, variants.sku AS sku, variants.threshold AS threshold  FROM
    products INNER JOIN variants ON variants.product_id=products.id WHERE products.shop_id = #{shop.id}"
  end

  
end

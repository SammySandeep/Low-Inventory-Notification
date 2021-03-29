class VariantsController < ApplicationController
  include ApplicationHelper
  before_action :set_variant, only: [:show, :edit, :update]

  def index
    @variants = find_shop_by_shopify_domain(session['shopify.omniauth_params']['shop'] ).variants.paginate(:page => params[:page], per_page: 50)
  end


  def show
  end

  def edit
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

end

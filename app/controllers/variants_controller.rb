class VariantsController < ApplicationController
  
  before_action :set_variant, except: [:index, :export_csv, :import_csv, :edit]
  before_action :shop_setting_created?, only: [:index]
  
  def index
    if !current_shop.sync_complete
      flash.now[:notice] = "Products are still being synced to the application. We will notify you via email once it is completed."
    else
      @variants = current_shop.variants
    end
  end

  def show
  end

  def edit
  end

  def export_csv
    ExportCsvJob.perform_later(shop_id: current_shop.id)
    respond_to do |format|
      format.html { redirect_to variants_path, notice: 'CSV Generation is in Queue, will send an email once done please be patient' }
    end
  end

  def import_csv
  end

  def update
    @variant.update(variant_params)
    respond_to do |format|
      format.js
    end
  end

  private

  def set_variant
    @variant = Variant.find(params[:id])
  end

  def variant_params
    params.require(:variant).permit(:local_threshold)
  end

end

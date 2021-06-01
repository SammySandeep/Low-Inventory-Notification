class VariantsController < ApplicationController
  
  before_action :set_variant, only: [:show, :update]
  before_action :shop_setting_created?
  
  def index
    if !current_shop.sync_complete
      flash.now[:notice] = "Products are still being synced to the application. We will notify you via email once it is completed."
    else
      respond_to do |format|
        format.html
        format.json { render json: VariantDatatable.new(params, shop: current_shop) }
      end
    end
  end

  def show
  end

  def edit
  end

  def export_csv
    ExportCsvJob.perform_later(shop_id: current_shop.id)
    respond_to do |format|
      format.js
    end 
  end

  def import_csv
  end

  def update_csv_threshold
    @import_csv_successful = ImportCsvService.new(shop_id: current_shop.id, file_path: params[:file].path).execute
    respond_to do |format|
      format.js
    end
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

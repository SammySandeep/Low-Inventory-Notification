class VariantsController < ApplicationController
  
  before_action :set_variant, only: [:update]
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

  def export_csv
    ExportCsvJob.perform_later(shop_id: current_shop.id)
    @export_csv_success_message = "Please wait while the products are being emailed as a CSV file.This will take few minutes!"
    respond_to do |format|
      format.js
    end 
  end

  def import_csv
  end

  def update_csv_threshold
    @import_csv_successful = ImportCsvService.new(shop_id: current_shop.id, file_path: params[:file].path).execute
    @import_csv_success_message = "Variants Threshold successfully updated!"
    @import_csv_error_message = "There was an error updating Variants Threshold. Please refer to the csv file format on the Home page."
    respond_to do |format|
      format.js
    end
  end

  def update
    global_threshold = current_shop.shop_setting.global_threshold
    @current_variant_threshold = @variant.threshold
    @update_threshold_success_message = "Threshold successfully updated!"
    @update_threshold_error_message = "Please enter a valid integer value to update!"
    if !(global_threshold == (params[:variant][:local_threshold].to_i))
      @variant.update(variant_params)
    else
      @variant.update(local_threshold: nil)
    end
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

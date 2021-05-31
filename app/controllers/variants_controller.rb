class VariantsController < ApplicationController
  
  before_action :set_variant, only: [:show, :update]
  before_action :shop_setting_created?
  
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
      format.js
    end 
  end

  def import_csv
    # binding.pry
    # variant_update = Variant.update_local_threshold_from_csv(params[:file].path)
    # respond_to do |format|
    #   if variant_update.result_status == 1
    #     format.html { redirect_to variants_path, notice: "Variants Treshold successfully updated" }
    #   else
    #     format.html { redirect_to variants_path, alert: "There was an error updating Variants Treshold" }
    #   end
    # end
  end

  # def import_csv
  #   variant_update = Variant.update_local_threshold_from_csv(params[:file].path)
  #   respond_to do |format|
  #     format.js
  #     # if variant_update.result_status == 1
  #     #   format.html { redirect_to variants_path, notice: "Variants Treshold successfully updated" }
  #     # else
  #     #   format.html { redirect_to variants_path, alert: "There was an error updating Variants Treshold" }
  #     # end
  #   end
  # end

  def update_csv_threshold
    @import_csv_successul = ImportCsvService.new(shop_id: current_shop.id, file_path: params[:file].path).execute
    respond_to do |format|
      if @import_csv_successul
        format.html { redirect_to variants_path, notice: "Variants Treshold successfully updated" }
      else
        format.html { redirect_to variants_path, alert: "There was an error updating Variants Treshold" }
      end
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

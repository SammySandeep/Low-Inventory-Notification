class VariantsController < ApplicationController
  before_action :set_variant, except: [:index, :export_csv, :import_csv]
  before_action :shop_setting_created?, only: [:index]
  
  def index
    if !current_shop.sync_complete
      flash.now[:notice] = "Products are still being synced to the application. We will notify you via email once it is completed."
    else
      @variants = current_shop.variants.paginate(:page => params[:page], per_page: 50)
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

class ReportsController < ApplicationController
  before_action :csv_params, only: %i[download]

  def index
    if current_shop.shop_setting.present?
      respond_to do |format|
        format.html
        format.json { render json: ReportDatatable.new(params, shop: current_shop, view_context: view_context) }
      end 
    else
      redirect_to new_shop_setting_path
    end
  end

  def download 
    @report = Report.find(params[:report_id])
    data = HTTParty.get(@report.file_url)
    send_data data.to_s, filename: @report.file_name, type: :csv, disposition: "attachment"
  end

  private

  def csv_params
    params.permit(:report_id)
  end

end

class ReportsController < ApplicationController
  before_action :csv_params, only: %i[download]

  def index
    if current_shop.shop_setting.present?
      @reports = current_shop.reports 
    else
      redirect_to new_shop_setting_path
    end
  end

  def download
    @report = Report.find(params[:format])
    redirect_to @report.file_url
  end

  private

  def csv_params
    params.permit(:report_id)
  end

end

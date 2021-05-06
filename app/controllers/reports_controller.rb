class ReportsController < ApplicationController
  before_action :csv_params, only: %i[download]

  def index
  end

  def download
    @report = Report.find(params[:report_id])
    redirect_to @report.file_url
  end

  private

  def csv_params
    params.permit(:report_id)
  end

end

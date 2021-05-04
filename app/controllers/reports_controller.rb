class ReportsController < ApplicationController
  before_action :csv_params, only: %i[download]

  def index

  end

  def download
    key = sanitize_url()
    source_obj = check_aws_s3_object(key)
    file_path = set_file_path(key)
    table = get_aws_s3_object(file_path, source_obj)
    send_data(table, :filename => "report.csv",
        :type => "text/csv", :disposition => "attachment")
    File.delete(file_path)
  end

  private 

  def get_aws_s3_object file_path, source_obj
    file = CSV.open(file_path, "wb")
    source_obj.get(response_target: file_path)
    table = CSV.parse(File.read(file_path), headers: true)
    return table
  end

  def set_file_path key
    "#{Rails.root}/public/#{key}"
  end

  def check_aws_s3_object key 
    s3 = Aws::S3::Resource.new(region: ENV['AWS_BUCKET_REGION'])
    source_obj = s3.bucket(ENV['AWS_BUCKET_NAME']).object(key)
    return source_obj
  end

  def sanitize_url
    csv_params[:key].gsub(" ","+").gsub("$"," ")
  end

  def csv_params
    params.permit(:key)
  end

end

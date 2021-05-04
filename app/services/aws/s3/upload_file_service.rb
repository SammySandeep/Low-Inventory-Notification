class Aws::S3::UploadFileService
    
    attr_reader :file

    AWS_BUCKET_NAME = ENV["AWS_BUCKET_NAME"]
    AWS_BUCKET_REGION = ENV['AWS_BUCKET_REGION']

    def initialize file: 
        @file = file
    end

    def execute
        s3_url = store_csv_object_into_s3 
        return s3_url
    end

    private

    def store_csv_object_into_s3
        bucket_name = ENV["AWS_BUCKET_NAME"]
        s3 = Aws::S3::Resource.new(region: ENV['AWS_BUCKET_REGION'])
        targetObj = s3.bucket(bucket_name).object('csv/'+self.file)
        targetObj.put(body: 'csv', acl: 'public-read', content_disposition: 'attachment')
        targetObj.upload_file(self.file)
        return targetObj
    end


end  

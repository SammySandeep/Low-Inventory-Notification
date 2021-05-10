class DigitalOcean::Spaces::UploadFileService

    SPACE_NAME = ENV["DO_SPACE_NAME"]
    API_KEY = ENV["DO_SPACES_API_KEY"]
    SECRET_KEY = ENV["DO_SPACES_SECRET_KEY"]
    ENDPOINT = "https://#{ENV["DO_SPACES_ENDPOINT"]}"
    REGION = ENV["DO_SPACES_REGION"]
    ACL = ENV["DO_ACL"]

    attr_reader :file_name, :file_contents, :path

    def initialize file_name:, file_contents:, path:
        @file_name = file_name
        @file_contents = file_contents
        @path = path
    end

    def execute
        client.put_object({
            bucket: SPACE_NAME,
            key: key,
            body: self.file_contents,
            acl: ACL
        })
        
        return self.file_name
    end

    private

    def client
        Aws::S3::Client.new(
            access_key_id: API_KEY,
            secret_access_key: SECRET_KEY,
            endpoint: ENDPOINT,
            region: REGION
        )
    end

    def key
        "#{self.path}/#{self.file_name}"
    end

end
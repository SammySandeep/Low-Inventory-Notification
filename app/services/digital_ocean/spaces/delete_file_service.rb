class DigitalOcean::Spaces::DeleteFileService

    SPACE_NAME = ENV["DO_SPACE_NAME"]
    API_KEY = ENV["DO_SPACES_API_KEY"]
    SECRET_KEY = ENV["DO_SPACES_SECRET_KEY"]
    ENDPOINT = "https://#{ENV["DO_SPACES_ENDPOINT"]}"
    REGION = ENV["DO_SPACES_REGION"]
    ACL = ENV["DO_ACL"]

    attr_reader :path, :file_name

    def initialize path:, file_name:
        @path = path
        @file_name = file_name
    end

    def execute
        client.delete_object({
            bucket: SPACE_NAME,
            key: key
        })
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
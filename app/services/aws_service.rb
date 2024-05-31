class AwsService 
    def initialize 
        if ENV["S3_PUBLIC_KEY"].nil? || ENV["S3_SECRET_KEY"].nil? || ENV["S3_URL"].nil? || ENV["S3_BUCKET"].nil?
            raise "S3_PUBLIC_KEY, S3_SECRET_KEY, S3_BUCKET and S3_URL must be set in .env file"
        end

        @aws_service = Aws::S3::Resource.new(
            credentials:Aws::Credentials.new( ENV['S3_PUBLIC_KEY'], ENV['S3_SECRET_KEY']),
            region: "sa-east-1"
        )
    end


    def insert(file, path)
        bucket = @aws_service.bucket(ENV['S3_BUCKET'])
        obj = bucket.object(path)
        obj.upload_file(file)
    end
end 


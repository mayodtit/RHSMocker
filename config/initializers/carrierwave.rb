CarrierWave.configure do |config|
  config.fog_credentials = {

      # required
      :provider               => 'AWS',
      :aws_access_key_id      => AWS_ACCESS_KEY_ID,
      :aws_secret_access_key  => AWS_SECRET_ACCESS_KEY,

      # optional
      :region                 => 'us-west-2'                    # defaults to 'us-east-1'
      #:host                   => 's3.example.com',             # defaults to nil
      #:endpoint               => 'https://s3.example.com:8080' # defaults to nil
  }

  config.fog_directory  = S3_BUCKET                               # required. s3 bucket name
  config.fog_public     = false                                   # optional, defaults to true
  config.fog_attributes = {'x-amz-server-side-encryption' => 'AES256', 'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end

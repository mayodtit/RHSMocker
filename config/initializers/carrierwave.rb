def s3_bucket
  ENV['S3_BUCKET'] || 'btr01-devlocal'
end

CarrierWave.configure do |config|
  config.fog_credentials = {

      # required
      :provider               => 'AWS',
      :aws_access_key_id      => 'AKIAJYP4DRAT7EQ3RREQ',
      :aws_secret_access_key  => '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',

      # optional
      :region                 => 'us-west-2'                    # defaults to 'us-east-1'
      #:host                   => 's3.example.com',             # defaults to nil
      #:endpoint               => 'https://s3.example.com:8080' # defaults to nil
  }

  config.fog_directory  = s3_bucket                               # required. s3 bucket name
  config.fog_public     = false                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end
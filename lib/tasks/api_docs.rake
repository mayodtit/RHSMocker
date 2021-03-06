namespace :api_docs do
  task :export => :environment do
    S3Uploader.upload_directory(docs_directory_path, S3_BUCKET,
                                {:s3_key => AWS_ACCESS_KEY_ID,
                                 :s3_secret => AWS_SECRET_ACCESS_KEY,
                                 :destination_dir => 'docs/',
                                 :threads => 4})
  end
end

def docs_directory_path
  'tmp/docs'
end

namespace :api_docs do
  task :export do
    S3Uploader.upload_directory(docs_directory_path, ENV['S3_BUCKET'],
                                {:s3_key => ENV['AWS_ACCESS_KEY_ID'],
                                 :s3_secret => ENV['AWS_SECRET_ACCESS_KEY'],
                                 :destination_dir => 'docs/',
                                 :threads => 4})
  end
end

def docs_directory_path
  'tmp/docs'
end

require 'archive/tar/minitar'

namespace :api_docs do
  task :export do
    Archive::Tar::Minitar.pack(docs_directory_path, Zlib::GzipWriter.new(File.open(gzip_file_path, 'wb')))
    s3_directory.files.create(:key => docs_filename, :body => File.open(gzip_file_path), :public => true)
  end

  task :import do
    File.open(gzip_file_path, 'wb'){|f| f.write(s3_directory.files.get(docs_filename).body)}
    Archive::Tar::Minitar.unpack(Zlib::GzipReader.new(File.open(gzip_file_path, 'rb')), Rails.root.to_s)
  end
end

def docs_directory_path
  'tmp/docs'
end

def gzip_file_path
  'tmp/docs.tar.gz'
end

def docs_filename
  'docs.tar.gz'
end

def s3_storage
  @s3_storage ||= Fog::Storage.new(:aws_access_key_id => ENV['AWS_ACCESS_KEY_ID'],
                                   :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
                                   :provider => 'AWS')
end

def s3_directory
  @s3_directory ||= s3_storage.directories.get(ENV['S3_BUCKET'])
end

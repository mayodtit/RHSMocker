require 'archive/tar/minitar'

namespace :docs do
  task :export do
    Archive::Tar::Minitar.pack(docs_directory_path, Zlib::GzipWriter.new(File.open(gzip_file_path, 'wb')))
  end

  task :import do
    Archive::Tar::Minitar.unpack(Zlib::GzipReader.new(File.open(gzip_file_path, 'rb')), Rails.root.to_s)
  end
end

def docs_directory_path
  'tmp/docs'
end

def gzip_file_path
  'tmp/docs.tar.gz'
end

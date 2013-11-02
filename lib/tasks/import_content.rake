require 'nokogiri'
require 'html/sanitizer'
include Math # for padding

namespace :admin do
  task :import_content => :environment do |t, args|
    skipped = []
    failed = []

    filenames = Dir.glob(args.extras.try(:any?) ? args.extras : './db/mayo_content/*.xml')
    num_files = filenames.count
    padding = Math::log10(num_files).ceil

    disable_solr if num_files > 1000

    filenames.each_with_index do |filename, i|
      log("Processing file #{(i + 1).to_s.rjust(padding)}/#{num_files}: #{filename}")
      importer = ContentImporter.new(Nokogiri::XML(File.open(filename)), logger)
      case importer.import
      when :skipped
        skipped << filename
      when :failed
        failed << filename
      end
    end

    enable_solr if num_files > 1000

    log("Skipped #{skipped.count} files:")
    skipped.each{|f| log("  #{f}")}
    log("Failed to process #{failed.count} files:")
    failed.each{|f| log("  #{f}")}
    log("Re-run failed: rake admin:import_content[#{failed.join(',')}]") if failed.any?
  end

  private

  def log(message)
    logger.info(message)
    puts(message)
  end

  def logger
    @logger ||= Logger.new('./log/import_content.log')
  end

  def disable_solr
    Sunspot.session = Sunspot::Rails::StubSessionProxy.new(Sunspot.session)
  end

  def enable_solr
    log("Re-indexing Solr for new Content, this could take a little while...")
    Sunspot.session = Sunspot.session.original_session
    Content.reindex
    Sunspot.commit
  end
end

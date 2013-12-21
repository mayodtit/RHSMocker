require 'nokogiri'
require 'zip'

namespace :admin do
  task import_symptoms: :environment do |t, args|
    filenames = Dir.glob(args.extras.try(:any?) ? args.extras : './db/symptom_checker/*.docx')

    filenames.each_with_index do |filename, i|
      log("Processing file #{filename}")
      zip = Zip::File.open(filename)
      xml = (Nokogiri::XML(zip.read("word/document.xml")){|x| x.noent}/"//w:p")
      importer = SymptomCheckerImporter.new(xml, filename, logger)
      importer.import
    end
  end

  task nuke_symptoms: :environment do
    Symptom.delete_all
    SymptomsFactor.delete_all
    Factor.delete_all
    FactorGroup.delete_all
    SymptomMedicalAdvice.delete_all
    SymptomMedicalAdviceItem.delete_all
    SymptomSelfcare.delete_all
    SymptomSelfcareItem.delete_all
    ContentsSymptomsFactor.delete_all
  end

  private

  def log(message)
    logger.info(message)
    puts(message)
  end

  def logger
    @logger ||= Logger.new('./log/import_symptoms.log')
  end
end

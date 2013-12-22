require 'nokogiri'
require 'zip'

namespace :admin do
  task import_symptoms: :environment do |t, args|
    filenames = Dir.glob(args.extras.try(:any?) ? args.extras : './db/symptom_checker/*.docx')

    filenames.each_with_index do |filename, i|
      log("Processing file #{filename}")
      zip = Zip::File.open(filename)
      xml = (Nokogiri::XML(zip.read("word/document.xml")){|x| x.noent}/"//w:p")
      SymptomCheckerImporter.new(xml).import
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

  task audit_symptoms: :environment do
    Symptom.order(:patient_type, :name).each do |symptom|
      log "#{symptom.name} (#{symptom.patient_type})"
      log "  Gender: #{symptom.gender}" if symptom.gender
      factors = symptom.factors.where('gender IS NOT NULL')
      if factors.any?
        log "  Factors:"
        factors.each do |factor|
          log "    #{factor.name}, Gender: #{factor.gender}"
        end
      end
      content_ids = ContentsSymptomsFactor.joins(:symptoms_factor => :symptom)
                                          .where(:symptoms => {:id => symptom.id})
                                          .joins(:content)
                                          .where('contents.symptom_checker_gender IS NOT NULL')
                                          .pluck(:content_id)
                                          .uniq
      if content_ids.any?
        contents = Content.where(:id => content_ids)
        log "  Contents:"
        contents.each do |content|
          log "    #{content.title}, Gender: #{content.symptom_checker_gender}"
        end
      end
    end
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

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
    Factor.delete_all
    FactorGroup.delete_all
    SymptomMedicalAdvice.delete_all
    SymptomMedicalAdviceItem.delete_all
    SymptomSelfcare.delete_all
    SymptomSelfcareItem.delete_all
    FactorContent.delete_all
  end

  task audit_symptoms: :environment do
    Symptom.order(:patient_type, :name).each do |symptom|
      log "#{symptom.name} (#{symptom.patient_type})"
      log "  Gender: #{symptom.gender}" if symptom.gender
      log "  FactorGroups:"
      symptom.factor_groups.order(:ordinal).each do |factor_group|
        log "    #{factor_group.name}, Ordinal: #{factor_group.ordinal}"
        log "    Factors:"
        factor_group.factors.each do |factor|
          log "      #{factor.name}"
          log "        Gender: #{factor.gender}" if factor.gender
          log "        Contents:"
          factor.contents.each do |content|
            log "          #{content.document_id} #{content.title}"
            log "            Gender: #{content.symptom_checker_gender}" if content.symptom_checker_gender
          end
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

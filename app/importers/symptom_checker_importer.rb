class SymptomCheckerImporter
  def initialize(xml_data)
    @parser = SymptomCheckerParser.new(xml_data)
  end

  def import
    @attributes = @parser.parse!
    create_models_from_attributes!
  end

  private

  def create_models_from_attributes!
    create_symptom!
    create_symptom_medical_advice!
    create_symptom_selfcare!
    create_factor_groups_and_factors!
    create_contents_symptoms_factors!
  end

  def create_symptom!
    @symptom = Symptom.where(@attributes[:symptom]).first_or_create!
  end

  def create_symptom_medical_advice!
    @attributes[:medical_advices].each do |advice|
      med_advice = SymptomMedicalAdvice.where(symptom_id: @symptom.id,
                                              description: advice[:description]).first_or_create!
      advice[:items].each do |item|
        SymptomMedicalAdviceItem.where(symptom_medical_advice_id: med_advice.id,
                                       description: item[:description],
                                       gender: item[:gender]).first_or_create!
      end
    end
  end

  def create_symptom_selfcare!
    @attributes[:selfcares].each do |attributes|
      selfcare = SymptomSelfcare.where(symptom_id: @symptom.id,
                                       description: attributes[:description]).first_or_create!
      attributes[:items].each do |item|
        SymptomSelfcareItem.where(symptom_selfcare_id: selfcare.id,
                                  description: item[:description]).first_or_create!
      end
    end
  end

  def create_factor_groups_and_factors!
    @attributes[:factor_groups].each do |factor_group_attributes|
      factor_group = @symptom.factor_groups.where(name: factor_group_attributes[:name].strip).first_or_create!
      factor_group_attributes[:factors].each do |factor_attributes|
        factor_group.factors.upsert_attributes({name: factor_attributes[:name].gsub(/\[.*\]/, '').strip}, {gender: factor_attributes[:gender]})
      end
    end
  end

  def create_contents_symptoms_factors!
    @attributes[:conditions].each do |condition_attributes|
      content = Content.find_by_document_id!(condition_attributes[:id])
      content.update_attributes!(symptom_checker_gender: condition_attributes[:gender]) if condition_attributes[:gender]
      condition_attributes[:matches].each do |match|
        factor_group = factor_group_for_search(@symptom, match)
        factor = factor_for_search(factor_group, match[(factor_group.name.length + 1)..match.length])
        FactorContent.where(content_id: content.id,
                            factor_id: factor.id).first_or_create!
      end
    end
  end

  def factor_group_for_search(symptom, search)
    symptom.reload.factor_groups.uniq.each do |factor_group|
      if /^#{Regexp.escape(factor_group.name)}\b/i.match(search)
        return factor_group
      end
    end
    raise "FactorGroup not found for '#{search}'"
  end

  def factor_for_search(factor_group, search)
    factor_group.reload.factors.uniq.each do |factor|
      if /^#{Regexp.escape(factor.name)}$/i.match(search)
        return factor
      end
    end
    raise "Factor not found for '#{search}'"
  end
end

class SymptomCheckerImporter
  def initialize(xml_data, filename)
    @data = xml_data
    @filename = Pathname.new(filename).basename.to_s
    @attributes = {}
    @index = 0
  end

  def import
    get_attributes_from_filename!
    read_lines_from_xml!
    parse_lines!
    create_models_from_attributes!
  end

  private

  def get_attributes_from_filename!
    @attributes[:symptom] = {
                              name: @filename.split('.')[0].split('_')[2].titleize,
                              patient_type: @filename.split('.')[0].split('_')[1].downcase
                            }
  end

  def read_lines_from_xml!
    @lines = @data.map{|field| (field/".//w:t").try(:inner_html)}
  end

  def parse_lines!
    get_symptom_description!
    get_medical_advice!
    get_selfcare_strategies!
    get_factors!
    get_conditions!
    create_models_from_attributes!
  end

  def get_symptom_description!
    advance_index_to_match!('tease')
    @attributes[:symptom][:description] = @lines[advance_index_past_blank!].strip
  end

  def get_medical_advice!
    advance_index_to_match!('when to get medical help')
    @attributes[:medical_advice] = {description: @lines[advance_index_past_blank!].strip,
                                    items: []}
    ((@index + 1)..(advance_index_to_match!('self-care strategies') - 1)).each do |i|
      next if @lines[i].blank?
      @attributes[:medical_advice][:items] << {description: @lines[i].strip}
    end
  end

  def get_selfcare_strategies!
    advance_index_to_match!('self-care strategies')
    @attributes[:selfcare] = {description: @lines[advance_index_past_blank!].strip,
                              items: []}
    ((@index + 1)..(advance_index_to_match!('more information') - 1)).each do |i|
      next if @lines[i].blank?
      @attributes[:selfcare][:items] << {description: @lines[i].strip}
    end
  end

  def get_factors!
    @index = advance_index_to_match!('END OF FARCRY TEXT')
    @index = advance_index_past_next_line!
    end_of_factors = find_index_of_match!('possible causes') - 1
    @attributes[:factor_groups] = []

    while @index < end_of_factors
      if @lines[@index].blank?
        @index += 1
        break if @index >= end_of_factors
      end
      factor_group = {name: @lines[@index], factors: []}
      @index += 1
      while (@lines[@index].present?)
        factor_group[:factors] << {name: @lines[@index].strip}
        @index += 1
      end
      @attributes[:factor_groups] << factor_group
    end
  end

  def get_conditions!
    advance_index_to_match!('DS')
    @attributes[:conditions] = []

    while @index < (@lines.count - 1)
      while @lines[@index].blank?
        @index += 1
      end
      return unless /DS/.match(@lines[@index].split(' ')[0])

      condition = {id: @lines[@index].split(' ')[0], matches: []}
      @index += 1
      while @lines[@index].present?
        condition[:matches] << @lines[@index].strip
        @index += 1
      end
      @attributes[:conditions] << condition
    end
  end

  def advance_index_to_match!(search)
    (@index..(@lines.count - 1)).each do |i|
      if /#{search}/i.match(@lines[i])
        return @index = i
      end
    end
    raise 'Match not found!'
  end

  def advance_index_past_next_line!
    advance_index_past_blank!
    @index += 1
  end

  def advance_index_past_blank!
    ((@index + 1)..(@lines.count - 1)).each do |i|
      if @lines[i].present?
        return @index = i
      end
    end
  end

  def find_index_of_match!(search)
    (@index..(@lines.count - 1)).each do |i|
      if /#{search}/i.match(@lines[i])
        return i
      end
    end
    raise 'Match not found!'
  end

  def create_models_from_attributes!
    @symptom = Symptom.upsert_attributes!({name: @attributes[:symptom][:name]},
                               @attributes[:symptom])
    med_advice = SymptomMedicalAdvice.upsert_attributes({symptom_id: @symptom.id},
                                                        {description: @attributes[:medical_advice][:description]})
    @attributes[:medical_advice][:items].each do |item|
      SymptomMedicalAdviceItem.where(symptom_medical_advice_id: med_advice.id,
                                     description: item[:description]).first_or_create!
    end
    selfcare = SymptomSelfcare.upsert_attributes({symptom_id: @symptom.id},
                                                 {description: @attributes[:selfcare][:description]})
    @attributes[:selfcare][:items].each do |item|
      SymptomSelfcareItem.where(symptom_selfcare_id: selfcare.id,
                                description: item[:description]).first_or_create!
    end
    @attributes[:factor_groups].each do |factor_group_attributes|
      factor_group = FactorGroup.where(name: factor_group_attributes[:name].strip).first_or_create!
      factor_group_attributes[:factors].each do |factor_attributes|
        factor = Factor.where(name: factor_attributes[:name].strip).first_or_create!
        SymptomsFactor.where(symptom_id: @symptom.id,
                             factor_group_id: factor_group.id,
                             factor_id: factor.id,
                             doctor_call_worthy: false,
                             er_worthy: false).first_or_create!
      end
    end
    @attributes[:conditions].each do |condition_attributes|
      content = Content.where(document_id: condition_attributes[:id]).first!
      condition_attributes[:matches].each do |match|
        factor_group = factor_group_for_search(match)
        factor = factor_for_search(match[(factor_group.name.length + 1)..match.length])
        symptoms_factor = SymptomsFactor.where(symptom_id: @symptom.id,
                                               factor_group_id: factor_group.id,
                                               factor_id: factor.id).first!
        ContentsSymptomsFactor.where(content_id: content.id,
                                     symptoms_factor_id: symptoms_factor.id).first_or_create!
      end
    end
  end

  def factor_group_for_search(search)
    @symptom.reload.factor_groups.uniq.each do |factor_group|
      if /^#{Regexp.escape(factor_group.name)}\b/i.match(search)
        return factor_group
      end
    end
    raise "FactorGroup not found for '#{search}'"
  end

  def factor_for_search(search)
    @symptom.reload.factors.uniq.each do |factor|
      if /^#{Regexp.escape(factor.name)}$/i.match(search)
        return factor
      end
    end
    raise "Factor not found for '#{search}'"
  end
end

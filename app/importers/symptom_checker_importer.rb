class SymptomCheckerImporter
  def initialize(xml_data)
    @data = xml_data
    @attributes = {symptom: {}}
    @index = 0
  end

  def import
    read_lines_from_xml!
    parse_lines!
    create_models_from_attributes!
  end

  private

  def read_lines_from_xml!
    @lines = @data.map{|field| (field/".//w:t").try(:inner_html)}
  end

  def parse_lines!
    get_symptom_attributes!
    get_medical_advice!
    get_selfcare_strategies!
    get_factors!
    get_conditions!
  end

  def get_symptom_attributes!
    get_symptom_title!
    get_symptom_description!
    get_symptom_gender!
    get_symptom_age!
  end

  def get_symptom_title!
    @attributes[:symptom][:name] = line_after_match_and_blanks('Title').strip
  end

  def get_symptom_description!
    @attributes[:symptom][:description] = line_after_match_and_blanks('tease').strip
  end

  def get_symptom_gender!
    case line_after_match_and_blanks('Gender')
    when 'Male'
      @attributes[:symptom][:gender] = 'M'
    when 'Female'
      @attributes[:symptom][:gender] = 'F'
    end
  end

  def get_symptom_age!
    @attributes[:symptom][:patient_type] = line_after_match_and_blanks('Age').downcase
  end

  def get_medical_advice!
    advance_index_to_match!('when to get medical help')
    advance_index_past_blank!
    end_of_medical_advice = find_index_of_match!('self-care strategies') - 1
    @attributes[:medical_advices] = []
    while @index < end_of_medical_advice
      if @lines[@index].blank?
        @index += 1
        break if @index >= end_of_medical_advice
      end
      medical_advice = {description: @lines[@index].gsub(/\(.*\)/, '').strip,
                        items: []}
      advance_index_past_blank!
      while (@lines[@index].present?)
        break if @index > end_of_medical_advice
        if /\[/.match(@lines[@index])
          if @lines[@index].gsub(/.*\[|\].*/, '') == 'female'
            gender = 'F'
          elsif @lines[@index].gsub(/.*\[|\].*/, '') == 'male'
            gender = 'M'
          else
            gender = nil
          end
        else
          gender = nil
        end
        medical_advice[:items] << {description: @lines[@index].gsub(/\[.*\]/, '').strip,
                                   gender: gender}
        @index += 1
      end
      @attributes[:medical_advices] << medical_advice
    end
  end

  def get_selfcare_strategies!
    advance_index_to_match!('self-care strategies')
    @attributes[:selfcare] = {description: line_after_match_and_blanks('self-care strategies').gsub(/\(.*\)/, '').strip,
                              items: []}
    next_index_to_match_range('more information').each do |i|
      next if @lines[i].blank?
      break if /IMAGE/i.match(@lines[i])
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
      factor_group = {name: @lines[@index].gsub(/\[.*\]/, '').strip, factors: []}
      @index += 1
      while (@lines[@index].present?)
        if /\[/.match(@lines[@index])
          if @lines[@index].gsub(/.*\[|\].*/, '') == 'female'
            gender = 'F'
          elsif @lines[@index].gsub(/.*\[|\].*/, '') == 'male'
            gender = 'M'
          else
            raise 'Unknown factor gender'
          end
        else
          gender = nil
        end
        factor_group[:factors] << {name: @lines[@index].gsub(/\[.*\]/, '').strip,
                                   gender: gender}
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

      if @lines[@index].include?('[')
        if @lines[@index].gsub(/.*\[|\].*/, '') == 'female'
          gender = 'F'
        elsif @lines[@index].gsub(/.*\[|\].*/, '') == 'male'
          gender = 'M'
        else
          raise 'Unknown condition gender'
        end
      else
        gender = nil
      end
      condition = {id: @lines[@index].split(' ')[0],
                   gender: gender,
                   matches: []}
      @index += 1
      while @lines[@index].present?
        condition[:matches] << @lines[@index].gsub(/\[.*\]/, '').strip
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

  def line_after_match_and_blanks(search)
    advance_index_to_match!(search)
    @lines[advance_index_past_blank!]
  end

  def next_index_to_match_range(search)
    (@index + 1)..(advance_index_to_match!(search) - 1)
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
    selfcare = SymptomSelfcare.upsert_attributes({symptom_id: @symptom.id},
                                                 {description: @attributes[:selfcare][:description]})
    @attributes[:selfcare][:items].each do |item|
      SymptomSelfcareItem.where(symptom_selfcare_id: selfcare.id,
                                description: item[:description]).first_or_create!
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

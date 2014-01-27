class SymptomCheckerParser
  include ImportContentModule

  def initialize(data)
    @lines = data.map{|field| (field/".//w:t").try(:inner_html)}
    @attributes = {symptom: {}}
    @index = 0
  end

  def parse!
    get_symptom_title!
    get_symptom_description!
    get_symptom_gender!
    get_symptom_age!
    get_medical_advice!
    get_selfcare_strategies!
    get_factors!
    get_conditions!
    @attributes
  end

  private

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
    @attributes[:symptom][:patient_type] = line_after_match_and_blanks('Age').downcase.strip
  end

  def get_medical_advice!
    advance_index_to_match!('when to get medical help')
    advance_index_past_blank!
    end_of_medical_advice = (find_index_of_match('self-care strategies') || find_index_of_match!('more information')) - 1
    @attributes[:medical_advices] = []
    while @index < end_of_medical_advice
      if @lines[@index].blank?
        @index += 1
        break if @index >= end_of_medical_advice
      end
      medical_advice = {description: @lines[@index].remove_last_parens.strip,
                        items: []}
      advance_index_past_blank!
      if /:$/.match(medical_advice[:description])
        while (@lines[@index].present?)
          break if @index > end_of_medical_advice
          case @lines[@index].in_brackets
          when 'female'
            gender = 'F'
          when 'male'
            gender = 'M'
          else
            gender = nil
          end
          medical_advice[:items] << {description: @lines[@index].remove_brackets.strip,
                                     gender: gender}
          @index += 1
        end
      end
      @attributes[:medical_advices] << medical_advice
    end
  end

  def get_selfcare_strategies!
    @attributes[:selfcares] = []
    unless find_index_of_match('self-care strategies')
      return
    end
    advance_index_to_match!('self-care strategies')
    advance_index_past_blank!
    end_of_selfcare = find_index_of_match!('more information')
    while @index < end_of_selfcare
      if @lines[@index].blank?
        @index += 1
        break if @index >= end_of_selfcare
      end
      break if /IMAGE/i.match(@lines[@index])
      break if /Because of the nature of this symptom/.match(@lines[@index])
      selfcare = {description: @lines[@index].remove_last_parens.strip,
                  items: []}
      advance_index_past_blank!
      if /:$/.match(selfcare[:description])
        while (@lines[@index].present?)
          break if @index > end_of_selfcare
          case @lines[@index].in_brackets
          when 'female'
            gender = 'F'
          when 'male'
            gender = 'M'
          else
            gender = nil
          end
          selfcare[:items] << {description: @lines[@index].remove_brackets.strip,
                                     gender: gender}
          @index += 1
        end
      end
      @attributes[:selfcares] << selfcare
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
      factor_group = {name: @lines[@index].remove_brackets.strip, factors: []}
      @index += 1
      while (@lines[@index].present?)
        case @lines[@index].in_brackets
        when 'female'
          gender = 'F'
        when 'male'
          gender = 'M'
        else
          gender = nil
        end
        factor_group[:factors] << {name: @lines[@index].remove_brackets.strip,
                                   gender: gender}
        @index += 1
      end
      @attributes[:factor_groups] << factor_group
    end
  end

  def get_conditions!
    advance_index_to_match!(/[A-Z]{2}[0-9]{5}/)
    @attributes[:conditions] = []
    while @index < (@lines.count - 1)
      while @lines[@index].blank?
        @index += 1
      end
      return unless /[A-Z]{2}[0-9]{5}/.match(@lines[@index].split(' ')[0])
      case @lines[@index].in_brackets
      when 'female'
        gender = 'F'
      when 'male'
        gender = 'M'
      else
        gender = nil
      end
      condition = {id: @lines[@index].split(' ')[0],
                   gender: gender,
                   matches: []}
      @index += 1
      while @lines[@index].present?
        condition[:matches] << @lines[@index].remove_brackets.strip
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

  def find_index_of_match(search)
    (@index..(@lines.count - 1)).each do |i|
      if /#{search}/i.match(@lines[i])
        return i
      end
    end
    nil
  end

  def find_index_of_match!(search)
    find_index_of_match(search) || raise('Match not found!')
  end
end

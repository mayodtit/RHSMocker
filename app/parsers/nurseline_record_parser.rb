class NurselineRecordParser
  def initialize(nurseline_record)
    @nurseline_record = nurseline_record
  end

  def parse!
    parse_html!
    parse_text!
    find_attributes!
    parsed_nurseline_record_attributes
  end

  private

  def parse_html!
    @html = Nokogiri::HTML(@nurseline_record.payload)
  end

  def parse_text!
    @text = @html.text
  end

  def find_attributes!
    @phone_call = PhoneCall.find_by_identifier_token!(phone_call_identifier_token)
    @user = @phone_call.user
    @consult = @phone_call.consult
  end

  def phone_call_identifier_token
    delimited_text = @text.split("\r\n")
    delimited_text.each_with_index do |line, i|
      if line.include?('Better consult id:')
        return delimited_text[i+1].strip
      end
    end
    raise 'Unable to find phone_call_identifier_token'
  end

  def create_parsed_nurseline_record!
    ParsedNurselineRecord.create(user: @user,
                                 consult: @consult,
                                 phone_call: @phone_call,
                                 nurseline_record: @nurseline_record,
                                 text: @text)
  end

  def parsed_nurseline_record_attributes
    {
      user: @user,
      consult: @consult,
      phone_call: @phone_call,
      nurseline_record: @nurseline_record,
      text: @text
    }
  end
end

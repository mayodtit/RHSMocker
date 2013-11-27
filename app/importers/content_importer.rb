class ContentImporter
  include ImportContentModule

  def initialize(xml_data, logger=nil)
    @data = xml_data
    @logger = logger
  end

  def import
    extract_required_params_from_xml!
    return :failed unless has_required_params?
    return :skipped unless allow_type?
    return RecipeImporter.new(@data, @logger).import if @content_type == 'Recipe'
    return MayoContentImporter.new(@data, @logger).import
  end

  protected

  TERMS_OF_SERVICE = 'AM00021'
  NO_CALL_LIST     = %w(HT00648 AM00021 HT00022 NU00585 NU00584)
  NO_SYMPTOMS_LIST = %w(HT00648 AM00021 HT00022 NU00585 NU00584)

  def log(message)
    @logger.info(message) if @logger
    puts(message)
  end

  def extract_required_params_from_xml!
    @document_id = @data.search('DocID').first.text.strip
    @content_type = @data.search('ContentType').first.text.strip
    @title = CGI.unescapeHTML(@data.search('Title').first.text.remove_newlines_and_tabs)
  end

  def has_required_params?
    unless (@data && @document_id && @content_type && @title)
      log("xml did not have required parameters")
      return false
    end
    true
  end

  def allow_type?
    if %(SelfAssessment).include?(@content_type)
      log("skipping #{@content_type}")
      return false
    end
    true
  end

  def create_content!
    @content = Content.upsert_attributes({:document_id => @document_id},
                                         {
                                           :type => 'MayoContent',
                                           :content_type => @content_type,
                                           :title => @title,
                                           :abstract => abstract,
                                           :question => question,
                                           :raw_body => body,
                                           :keywords => keywords,
                                           :content_updated_at => content_updated_at,
                                           :show_call_option => !NO_CALL_LIST.include?(@document_id),
                                           :show_checker_option => !NO_SYMPTOMS_LIST.include?(@document_id),
                                           :show_mayo_copyright => (@document_id != TERMS_OF_SERVICE),
                                           :state_event => :publish
                                         })
  end

  def abstract
    if %w(Condition TestProcedure).include?(@content_type)
      @html.css('p').first.inner_html.remove_newlines_and_tabs
    else
      @data.search('Abstract').first.try(:text).try(:remove_newlines_and_tabs)
    end
  end

  def question
    @data.search('Question').first.try(:text).try(:remove_newlines_and_tabs)
  end

  def body
    Nokogiri::HTML.fragment(@html.search('body').to_html).to_html
  end

  def keywords
    @data.search('MetaKeyword').map{|k| k.text.remove_newlines_and_tabs}.join(',')
  end

  def content_updated_at
    @data.search('UpdateDate').first.try(:text).try(:remove_newlines_and_tabs)
  end

  def create_content_vocabularies!
    @data.search('Keyword').each do |keyword|
      vocab = MayoVocabulary.find_or_create_by_mcvid_and_title!(keyword.attributes['MCVID'].value,
                                                                keyword.attributes['Title'].value)
      @content.mayo_vocabularies << vocab unless @content.mayo_vocabularies.include?(vocab)
    end
  end
end

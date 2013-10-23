class ContentImporter
  include ImportContentModule

  def initialize(xml_data, logger=nil)
    @data = xml_data
    @logger = logger
    @mayo_doc_id = @data.search('DocID').first.text.strip
    @type = @data.search('ContentType').first.text.strip
    @title = @data.search('Title').first.text.strip.gsub(/,/," ")
  end

  def import
    return false unless preprocess
    create_content
    create_content_vocabularies
    true
  end

  def skipped?
    @skipped || false
  end

  def failed?
    @failed || false
  end

  private

  def log(message)
    formatted_message = "#{@mayo_doc_id}, #{@type}, #{@title}, #{message}"
    logger.info(formatted_message) if @logger
    puts(formatted_message)
  end

  def skip(message)
    @skipped = true
    log(message)
    false
  end

  def fail(message)
    @failed = true
    log(message)
    false
  end

  def preprocess
    # skip SelfAssessments and Recipes
    if %(SelfAssessment Recipe).include?(@type)
      return skip("skipping #{@type}")
    end

    # remove flash assets
    @data.css('Flash').each do |node|
      node.remove
    end

    # remove PopupMedia assets
    @data.css('PopupMedia').each do |node|
      node.at_css('HTML').remove
    end

    # add markup to sections
    sections = @data.css('Section')
    sections.each_with_index do |section, i|
      section_head = section.at("SectionHead")
      next unless section_head.content.to_s.present?
      section_head.children = Nokogiri::XML::Text.new("<div class=\"section-head closed#{" last" if i == (sections.count - 1)}\" data-section-id=#{i}>#{section_head.content.strip.remove_leading_numbered_list}</div>", section_head)
      section_html = section.at("HTML")
      section_html.children = Nokogiri::XML::Text.new("<div class=\"section disabled #{" last" if i == (sections.count - 1)}\" id=\"section-#{i}\">#{section_html.content}</div>", section_html)
    end

    # extract HTML body from data
    body = @data.css('Body').first
    return fail("content did not have a body tag") unless body
    @html = Nokogiri::HTML(body.text.remove_newlines_and_tabs
                                     .remove_hr_tags
                                     .remove_br_tags)

    # add absolute URL to inline images
    @html.search('div.inlineimage.right').each do |image|
      image_tag = image.at_css('img')
      image_url = image_tag['src']
      image_tag.remove
      image.set_attribute('class', 'authorImageDiv')
      image.content = ''
      image.set_attribute('style', "background-image:url(\"http://www.mayoclinic.com#{image_url}\")")
    end

    # interlace unique images with text
    html_paragraphs = @html.css('p')
    urls = @data.css('PopupMedia').map{|pm| 'http://www.mayoclinic.com' + pm.at_css('Image')['URI']}.uniq
    url_index = 0
    html_paragraphs.each_with_index do |p, i|
      break unless urls[url_index]
      next if i < 2 # skip the first 2 paragraphs
      next if %w(ul ol).include?(p.next_sibling.try(:name))
      node = Nokogiri::XML::Node.new('img', @data)
      node.set_attribute('class', 'mayoContentImage')
      node.set_attribute('src', urls[url_index])
      p.add_next_sibling(node)
      url_index += 1
    end

    true
  end

  def create_content
    params = {}
    params[:mayo_doc_id] = @data.search('DocID').first.text.strip
    params[:content_type] = @data.search('ContentType').first.text.strip
    params[:title] = CGI.unescapeHTML(@data.search('Title').first.text.remove_newlines_and_tabs)
    params[:abstract] = if %w(Condition TestProcedure).include?(params[:content_type])
                                  @html.css('p').first.inner_html.remove_newlines_and_tabs
                                else
                                  @data.search('Abstract').first.try(:text).try(:remove_newlines_and_tabs)
                                end
    params[:question] = @data.search('Question').first.try(:text).try(:remove_newlines_and_tabs)
    params[:body] = Nokogiri::HTML.fragment(@html.search('body').to_html).to_html
    params[:keywords] = @data.search('MetaKeyword').map{|k| k.text.remove_newlines_and_tabs}.join(',')
    params[:content_updated_at] = @data.search('UpdateDate').first.text.remove_newlines_and_tabs
    params[:show_call_option] = show_call_for_doc_id?(params[:mayo_doc_id])
    params[:show_checker_option] = show_symptoms_for_doc_id?(params[:mayo_doc_id])
    @content = Content.upsert_attributes({:mayo_doc_id => params[:mayo_doc_id]}, params)
  end

  def create_content_vocabularies
    @data.search('Keyword').each do |keyword|
      vocab = MayoVocabulary.find_or_create_by_mcvid_and_title!(keyword.attributes['MCVID'].value,
                                                                keyword.attributes['Title'].value)
      @content.mayo_vocabularies << vocab unless @content.mayo_vocabularies.include?(vocab)
    end
  end

  NO_CALL_LIST     = %w(HT00648 AM00021 HT00022 NU00585 NU00584)
  NO_SYMPTOMS_LIST = %w(HT00648 AM00021 HT00022 NU00585 NU00584)

  def show_call_for_doc_id?(doc_id)
    !NO_CALL_LIST.include?(doc_id)
  end

  def show_symptoms_for_doc_id?(doc_id)
    !NO_SYMPTOMS_LIST.include?(doc_id)
  end
end

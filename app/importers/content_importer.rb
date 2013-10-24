class ContentImporter
  include ImportContentModule

  def initialize(xml_data, logger=nil)
    @data = xml_data
    @logger = logger
  end

  def import
    extract_required_params_from_xml!
    return false unless has_required_params?
    return false unless allow_type?
    remove_flash_assets!
    remove_popup_media!
    add_section_markup! unless @mayo_doc_id == TERMS_OF_SERVICE
    return false unless has_html?
    extract_html_from_xml!
    add_absolute_url_to_images!
    insert_images_into_html!
    create_content!
    create_content_vocabularies!
    true
  end

  def skipped?
    @skipped || false
  end

  def failed?
    @failed || false
  end

  private

  TERMS_OF_SERVICE = 'AM00021'
  NO_CALL_LIST     = %w(HT00648 AM00021 HT00022 NU00585 NU00584)
  NO_SYMPTOMS_LIST = %w(HT00648 AM00021 HT00022 NU00585 NU00584)

  def log(message)
    formatted_message = "#{@mayo_doc_id}, #{@content_type}, '#{@title}', #{message}"
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

  def extract_required_params_from_xml!
    @mayo_doc_id = @data.search('DocID').first.text.strip
    @content_type = @data.search('ContentType').first.text.strip
    @title = CGI.unescapeHTML(@data.search('Title').first.text.remove_newlines_and_tabs)
  end

  def has_required_params?
    unless (@data && @mayo_doc_id && @content_type && @title)
      return failed("xml did not have required parameters")
    end
    true
  end

  def allow_type?
    if %(SelfAssessment Recipe).include?(@content_type)
      return skip("skipping #{@content_type}")
    end
    true
  end

  def remove_flash_assets!
    @data.css('Flash').each do |node|
      node.remove
    end
  end

  def remove_popup_media!
    @data.css('PopupMedia').each do |node|
      node.at_css('HTML').remove
    end
  end

  def add_section_markup!
    sections = @data.css('Section')
    sections.each_with_index do |section, i|
      next unless replace_section_head!(i, section, sections.count)
      replace_section!(i, section, sections.count)
    end
  end

  def replace_section_head!(id, section, count)
    section_head = section.at("SectionHead")
    return false unless section_head.content.present?
    section_head.children = section_head_node(id, section_head, id == count - 1)
    true
  end

  def replace_section!(id, section, count)
    section_html = section.at("HTML")
    section_html.children = section_node(id, section_html, id == count - 1)
  end

  def section_head_node(id, section_head, last=false)
    Nokogiri::XML::Text.new("<div class=\"section-head closed#{" last" if last}\" data-section-id=#{id}>#{section_head.content.strip.remove_leading_numbered_list}</div>", section_head)
  end

  def section_node(id, section_html, last=false)
    Nokogiri::XML::Text.new("<div class=\"section disabled#{" last" if last}\" id=\"section-#{id}\">#{section_html.content}</div>", section_html)
  end

  def has_html?
    body = @data.css('Body').first
    return fail("content did not have a body tag") unless body
    true
  end

  def extract_html_from_xml!
    body = @data.css('Body').first
    @html = Nokogiri::HTML(body.text.remove_newlines_and_tabs
                                     .remove_hr_tags
                                     .remove_br_tags)
  end

  def add_absolute_url_to_images!
    @html.search('div.inlineimage.right').each do |image|
      image_tag = image.at_css('img')
      image_url = image_tag['src']
      image_tag.remove
      image.set_attribute('class', 'authorImageDiv')
      image.content = ''
      image.set_attribute('style', "background-image:url(\"http://www.mayoclinic.com#{image_url}\")")
    end
  end

  def insert_images_into_html!
    url_index = 0
    @html.css('p').each_with_index do |p, i|
      break unless image_urls[url_index]
      next if i < 2 # skip the first 2 paragraphs
      next if %w(ul ol).include?(p.next_sibling.try(:name)) # skip spaces before lists
      add_image_node!(p, image_urls[url_index])
      url_index += 1
    end
  end

  def image_urls
    @image_urls ||= @data.css('PopupMedia').map{|pm| 'http://www.mayoclinic.com' + pm.at_css('Image')['URI']}.uniq
  end

  def add_image_node!(parent, url)
    node = Nokogiri::XML::Node.new('img', @data)
    node.set_attribute('class', 'mayoContentImage')
    node.set_attribute('src', url)
    parent.add_next_sibling(node)
  end

  def create_content!
    @content = Content.upsert_attributes({:mayo_doc_id => @mayo_doc_id},
                                         {
                                           :content_type => @content_type,
                                           :title => @title,
                                           :abstract => abstract,
                                           :question => question,
                                           :body => body,
                                           :keywords => keywords,
                                           :content_updated_at => content_updated_at,
                                           :show_call_option => !NO_CALL_LIST.include?(@mayo_doc_id),
                                           :show_checker_option => !NO_SYMPTOMS_LIST.include?(@mayo_doc_id),
                                           :show_mayo_copyright => (@mayo_doc_id != TERMS_OF_SERVICE)
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

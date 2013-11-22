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
    remove_flash_assets!
    remove_popup_media!
    add_section_markup! unless @document_id == TERMS_OF_SERVICE
    return :failed unless has_html?
    extract_html_from_xml!
    return :failed unless has_body_content?
    add_absolute_url_to_images!
    format_inline_images!
    insert_images_into_html!
    create_intro_paragraph!
    create_content!
    create_content_vocabularies!
    :success
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

  def create_intro_paragraph!
    return unless promote_first_paragraph?
    @html.at('body').children.first.add_previous_sibling('<div class="intro">' + @html.at('p').to_html.remove_newlines_and_tabs + '</div>')
  end

  def promote_first_paragraph?
    (@html.at('body').children.first['class'] || '').split(/\s/).include?("section-head")
  end

  def has_html?
    unless @data.css('Body').first
      log("content did not have a body tag")
      return false
    end
    true
  end

  def has_body_content?
    @html.at('body').try(:children).try(:any?)
  end

  def extract_html_from_xml!
    @html = Nokogiri::HTML(@data.css('Body').first.text.remove_newlines_and_tabs
                                                       .remove_hr_tags
                                                       .remove_br_tags)
  end

  def add_absolute_url_to_images!
    @html.search('img').each do |image|
      image['src'] = "http://www.mayoclinic.com#{image['src']}"
    end
  end

  def format_inline_images!
    @html.search('.inlineimage').each do |inlineimage|
      inlineimage.attributes['style'].try(:remove)
      if inlineimage.at_css('img')['width'] == '138'
        inlineimage['class'] = 'author-image'
      end
    end
  end

  def insert_images_into_html!
    image_urls = @data.css('PopupMedia').map{|pm| 'http://www.mayoclinic.com' + pm.at_css('Image')['URI']}.uniq
    @html.css('p').drop(2).each do |p|
      break if image_urls.empty?
      next if %w(ul ol).include?(p.next_sibling.try(:name)) # skip spaces before lists
      add_image_node!(p, image_urls.shift)
    end
  end

  def add_image_node!(parent, url)
    node = Nokogiri::XML::Node.new('img', @data)
    node['class'] = 'mayoContentImage'
    node['src'] = url
    parent.add_next_sibling(node)
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
                                           :state => :published
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

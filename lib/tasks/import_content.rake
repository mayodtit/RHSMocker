#Import Cinical Content from Mayo Into the database
require 'nokogiri'
require 'html/sanitizer'

namespace :admin do

  task :import_content=> :environment do
    include ImportContentModule

    logger = Logger.new('./log/import_content.log')

    Dir.glob('./db/mayo_content/*.xml') do | contentFile |
      rawData = Nokogiri::XML(File.open(contentFile))
      docID 	= rawData.search('DocID').first.text.strip
      type 	= rawData.search('ContentType').first.text.strip
      title   = rawData.search('Title').first.text.strip.gsub(/,/," ")
      #logger.info(docID + ", Processing , " + "----------")

      if type.casecmp("SelfAssessment") == 0 			#SKIP SELF ASSESSMENTS FOR NOW
        logger.info(docID + "," + type + "," + title + ", Skipping SelfAssessment")
        next
      elsif type.casecmp("Recipe") == 0 				#SKIP RECIPIES FOR NOW
        logger.info(docID + "," + type + "," + title + ", Skipping Recipe")
        next
      elsif type.casecmp("HealthTip") == 0 			#REFORMAT HEALTH TIPS BUT CONTINUE
        logger.info(docID + "," + type + "," + title + ", Reformatting HealthTip")
        body_tag = rawData.at('Body')
        body_tag.inner_html = "<HTML>#{body_tag.inner_html}</HTML>"
      elsif rawData.css('HTML').empty?
        logger.info(docID + "," + type + "," + title + ", Has NO HTML and not clear why ---- DEBUG ME!")
        next
      end

      #Preprocssing specific text items
      #================================

      #1 Remove any code referring to Flash (example, NU00584.xml)
      flashNodes = rawData.css 'Flash'
      flashNodes.map do |flash_node|
        logger.info(docID + "," + type + "," + title + ", Has Embedded Flash")
        flash_node.remove
      end

      #Remove extra HTML sections that come right after pictures (They are partial text and not for showing)
      popup_media_nodes = rawData.css "PopupMedia"
      popup_media_nodes.map do | popup_node |
        logger.info(docID + "," + type + "," + title + ", Has Popup Media")
        popup_node.at_css('HTML').remove
      end

      #2 Change all <SectionHead> to div with <section_head id and class>
      #Have to drop into xpath b/c normal node creation will not get converted correctly to HTML
      rawData.xpath("//Section").each{ |section_node|
        section_head_node = section_node.at("SectionHead")
        if !section_head_node.nil? && !section_head_node.content.nil? && !section_head_node.content.to_s.blank?
          idName = section_head_node.content.to_s.gsub!(/\s+/, "").downcase
          idName = idName.gsub(/[-?'':,.]/, "")
          #var%20this_element=document.getElementById(#{idName}_header);this_element.className=(this_element.className==%27div.section_head.show%27)?%27div.section_head.hide%27:%27div.section_head.show%27;
          javascriptFunction = "javascript:%24(#{idName}_section).toggle();var%20this_element=document.getElementById('#{idName}_header');this_element.className=(this_element.className=='section_head_show')?'section_head_hide':'section_head_show';"
          section_head_node.swap("&lt;div class='section_head_show' id=#{idName}_header &gt;&lt;a href=#{javascriptFunction} &gt;#{section_head_node}&lt;/a&gt;&lt;/div&gt;")

          html_node = section_node.at("HTML")
          html_node.swap("&lt;div class='section' id=#{idName}_section&gt;#{html_node}&lt;/div&gt;")
        end
      }

      #2 Remove hr and return/tab tags, which Mayo interjects seemingly semi-randomly, Remove all horizontal rules, <br> HTML, and hiddem chars
      #Body can be empty, so need to handle that
      structured_body = Nokogiri::HTML(rawData.css('Body').first.text.remove_newlines_and_tabs.remove_hr_tags.remove_br_tags)

      #3 Change strong tags
      strongNodes = structured_body.css 'strong'
      strongNodes.map do |strong_node|
        strongText = strong_node.inner_html.remove_newlines_and_tabs.remove_hr_tags.remove_br_tags
        strong_node.swap("<div class='subtitle'>#{strongText}</div>")
        logger.info(docID + "," + type + "," + title + ", Has a subtitles")
      end

      tableNodes = structured_body.search 'div.mctable'
      tableNodes.map do |table_node|
        logger.info(docID + "," + type + "," + title + ", Has a Table")
      end

      #4 Cleanup Images
      divNodes = structured_body.search('div.inlineimage.right')
      divNodes.map do |image_div_node|
        logger.info(docID + "," + type + "," + title + ", Has Embedded Author Image")
        #change the class of this div, remove style

        image_div_node.set_attribute('class', 'authorImageDiv')
        #Make a background image and remove the img tag
        author_image = image_div_node.at_css('img')
        original_src = author_image['src']
        author_image.remove
        #remove any lable text
        image_div_node.content = ""
        bgImage = "background-image:url(' " + 'http://www.mayoclinic.com' + original_src +" ')"
        image_div_node.set_attribute('style', bgImage)
      end

      popup_media_nodes = rawData.css "PopupMedia"
      count = 0;
      popup_media_nodes.map do | popup_node |
        #Previously removed the extra HTML tag
        count+=1;
        thumb_img_node = Nokogiri::XML::Node.new "img", rawData
        thumb_img_node.set_attribute('class', 'mayoContentImage')
        full_img_src = 'http://www.mayoclinic.com' + popup_node.at_css('Image')['URI']
        thumb_img_node.set_attribute('src', full_img_src)
        #Total hack to skip second paragraph where the banner goes
        count = 3 if count == 2
        #structured_body.at_xpath('//p[$count]', {:count => count}).add_next_sibling(thumb_img_node)
        #THIS IS A HUGE FUCKING HACK.
        pcount = 0;
        structured_body.css('p').each do |p|
          pcount += 1;
          p.add_next_sibling(thumb_img_node) if pcount == count
        end
      end

      # Create objects
      type_search		= rawData.search('Meta ContentType')
      type_text	  	= type_search.first.text             if !type_search.empty?
      type_text 		= type_text.remove_newlines_and_tabs if !type_text.nil?

      title_search 		= rawData.search('Title')
      abstract_search 	= rawData.search('Abstract')
      question_search 	= rawData.search('Question')
      keyword_search		= rawData.search('MetaKeyword')
      update_search		= rawData.search('UpdateDate')
      mayo_vocab_search 	= rawData.search('Keyword')
      doc_id_search 		= rawData.search('DocID')

      title_text 	  = title_search.first.text 		if !title_search.empty?
      abstract_text = abstract_search.first.text 		if !abstract_search.empty?
      question_text = question_search.first.text 		if !question_search.empty?
      update_text	  = update_search.first.text    	if !update_search.empty?
      doc_id	   	  = doc_id_search.first.text.strip 	if !doc_id_search.empty?

      #If this is type disease, put in an abstract paragraph since diseases have very unfriendly abstract
      if type.casecmp("Disease") == 0
        abstract_text = structured_body.css('p').first.inner_html
        logger.info("Abstract = " + abstract_text)
        #type = "Condition"
        #elsif type.casecmp("TestProcedure") == 0
        #type = "Tests & Procedures"
      end

      body_text	  = Nokogiri::HTML.fragment(structured_body.search('body').to_html).to_html #case sensative on the re-created HTML document

      keywords = ''
      keyword_search.each do | keyword |
        keywords += keyword.text.remove_newlines_and_tabs + ','
      end

      title              = CGI.unescapeHTML(title_text.remove_newlines_and_tabs) if !title_text.nil?
      abstract           = abstract_text.remove_newlines_and_tabs                if !abstract_text.nil?
      question           = question_text.remove_newlines_and_tabs                if !question_text.nil?
      content_updated_at = update_text.remove_newlines_and_tabs                  if !update_text.nil?

      show_call = show_call_for_doc_id?(doc_id)
      show_symptoms = show_symptoms_for_doc_id?(doc_id)

      params = { title: title,
                 abstract: abstract,
                 question: question,
                 body: body_text,
                 keywords: keywords,
                 show_call_option: show_call,
                 show_checker_option: show_symptoms }
      params_for_find = params.merge({ mayo_doc_id: doc_id,
                                       content_type: type,
                                       content_updated_at: content_updated_at })

      @content = Content.find_or_create_by_mayo_doc_id(params_for_find)
      @content.update_attributes(params) if @content.present?

      mayo_vocab_search.each do | vocab |
        #If it exists, do nothing except join table
        #if it does not exist, put it in the DB

        mcvidList = MayoVocabulary.where(:mcvid => vocab.attributes["MCVID"].value)

        if mcvidList && mcvidList.count == 0
          @mayoVocab = MayoVocabulary.new()
          @mayoVocab.mcvid = vocab.attributes["MCVID"].value
          @mayoVocab.title = vocab.attributes["Title"].value
          @mayoVocab.save! #took off validation since it's okay to re-save.

        elsif mcvidList &&
          @mayoVocab = mcvidList.first #TODO: need to add constraint on MCVID

        end

        mcvidListForContent = ContentMayoVocabulary.where(:content => @content)

        #TODO: Makke this smarter to allow for updating mcvids for content
        if !@mayoVocab.nil? && mcvidListForContent.nil?
          @content.mayo_vocabularies << @mayoVocab
          #ContentMayoVocabulary.create(mayo_vocabulary:@mayoVocab, content:@content)
        end
      end
    end
  end


#################################################
# Task Import Content IDS
#################################################
  task :import_content_ids=> :environment do

    Dir.glob('./db/mayo_content/*.xml') do | answerFile |

      print "."
      #puts "Found File: #{answerFile}"
      answer = Nokogiri::XML(open(answerFile))


      type_search		= answer.search('Meta ContentType')
      type_text	  	= type_search.first.text 		if !type_search.empty?

      #TODO: would much prefer to do this as an "in" clause. This is lazycode
      #TODO: type_text could be null here. Add safe check
      type_text = type_text.remove_newlines_and_tabs

      if type_text.casecmp("answer") == 0 || type_text.casecmp("disease") == 0 || type_text.casecmp("article") == 0 || type_text.casecmp("firstaid") == 0 || type_text.casecmp("healthtip") == 0 || type_text.casecmp("TestProcedure") == 0

        title_search  = answer.search('Title')
        doc_id_search = answer.search('DocID')

        title_text 	  = title_search.first.text 	    if !title_search.empty?
        doc_id	   	  = doc_id_search.first.text.strip  if !doc_id_search.empty?


        @content = Content.find_by_title title_text.remove_newlines_and_tabs
        @content.mayo_doc_id = doc_id if !doc_id.nil?
        @content.save!
      end
    end
  end
#################################################
# Task: Migrate Content IDS
#################################################

  task :migrate_content_ids => :environment do

    UserReading.all.each do |ur|
      ur.update_attribute :content_id, ur.content.mayo_doc_id if ur.content && ur.content.mayo_doc_id
    end

    Message.all.each do |message|
      message.update_attribute :content_id, message.content.mayo_doc_id if message.content && message.content.mayo_doc_id
    end

    ContentMayoVocabulary.all.each do |cmv|
      cmv.update_attribute :content_id, cmv.content.mayo_doc_id if cmv.content && cmv.content.mayo_doc_id
    end

    ContentsSymptomsFactor.all.each do |csf|
      csf.update_attribute :content_id, csf.content.mayo_doc_id if csf.content && csf.content.mayo_doc_id
    end

    AuthorsContent.all.each do |ac|
      ac.update_attribute :content_id, ac.content.mayo_doc_id if ac.content && ac.content.mayo_doc_id
    end
  end
end

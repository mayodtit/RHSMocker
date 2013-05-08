#Import Cinical Content from Mayo Into the database
require 'nokogiri'

namespace :admin do

	task :import_content=> :environment do
		Dir.glob('./db/mayo_content/*.xml') do | answerFile |

			print "."
			#puts "Found File: #{answerFile}"
			answer = Nokogiri::XML(open(answerFile))


			type_search		= answer.search('Meta ContentType')
			type_text	  	= type_search.first.text 		if !type_search.empty?

			#TODO: would much prefer to do this as an "in" clause. This is lazycode
			#TODO: type_text could be null here. Add safe check
			type_text = type_text.gsub(/\n/,"").gsub(/\t/,"") 

			if type_text.casecmp("answer") == 0 || type_text.casecmp("disease") == 0 || type_text.casecmp("article") == 0 || type_text.casecmp("firstaid") == 0 || type_text.casecmp("healthtip") == 0 || type_text.casecmp("TestProcedure") == 0

				title_search 	= answer.search('Title')
				abstract_search = answer.search('Abstract')
				question_search = answer.search('Question')
				body_search		= answer.search('Body')
				keyword_search	= answer.search('MetaKeyword')
				update_search	= answer.search('UpdateDate')
				mayo_vocab_search = answer.search('Keyword')
				doc_id_search = answer.search('DocID')

				title_text 	  = title_search.first.text 	if !title_search.empty?
				abstract_text = abstract_search.first.text 	if !abstract_search.empty?
				question_text = question_search.first.text 	if !question_search.empty?
				body_text	  = body_search.first.text 		if !body_search.empty?
				update_text	  = update_search.first.text    if !update_search.empty?
				doc_id	   	  = doc_id_search.first.text.strip    if !doc_id_search.empty?

				keywords = ''

				keyword_search.each do | keyword |
					keywords += keyword.text.gsub(/\n/,"").gsub(/\t/,"") + ','
				end


				@content = Content.new()

				@content.id = doc_id
				@content.title 		= CGI.unescapeHTML(title_text.gsub(/\n/,"").gsub(/\t/,"")) 		if !title_text.nil?
				@content.abstract 	= abstract_text.gsub(/\n/,"").gsub(/\t/,"") 	if !abstract_text.nil?
				@content.question 	= question_text.gsub(/\n/,"").gsub(/\t/,"") 	if !question_text.nil?
				@content.body 		= body_text.gsub(/\n/,"").gsub(/\t/,"") 		if !body_text.nil?
				@content.contentsType = type_text.gsub(/\n/,"").gsub(/\t/,"").titlecase if !type_text.nil?
				@content.updateDate = update_text.gsub(/\n/,"").gsub(/\t/,"") 		if !update_text.nil?
				@content.keywords 	= keywords
				@content.mayo_doc_id = doc_id if !doc_id.nil?
				@content.save!

				mayo_vocab_search.each do | vocab |
				#If it exists, do nothing except join table
				#if it does not exist, put it in the DB

					mcvidList = MayoVocabulary.where(:mcvid => vocab.attributes["MCVID"].value)

					if mcvidList && mcvidList.count == 0 
						@mayoVocab = MayoVocabulary.new()
						@mayoVocab.mcvid = vocab.attributes["MCVID"].value
						@mayoVocab.title = vocab.attributes["Title"].value
						@mayoVocab.save!

					elsif mcvidList
						@mayoVocab = mcvidList.first #TODO: need to add constraint on MCVID

					end

					if !@mayoVocab.nil?
						@content.mayo_vocabularies << @mayoVocab
						#ContentVocabulary.create(mayo_vocabulary:@mayoVocab, content:@content)
					end

				end
			end
		end
	end



	task :import_content_ids=> :environment do

		Dir.glob('./db/mayo_content/*.xml') do | answerFile |

			print "."
			#puts "Found File: #{answerFile}"
			answer = Nokogiri::XML(open(answerFile))


			type_search		= answer.search('Meta ContentType')
			type_text	  	= type_search.first.text 		if !type_search.empty?

			#TODO: would much prefer to do this as an "in" clause. This is lazycode
			#TODO: type_text could be null here. Add safe check
			type_text = type_text.gsub(/\n/,"").gsub(/\t/,"") 

			if type_text.casecmp("answer") == 0 || type_text.casecmp("disease") == 0 || type_text.casecmp("article") == 0 || type_text.casecmp("firstaid") == 0 || type_text.casecmp("healthtip") == 0 || type_text.casecmp("TestProcedure") == 0

				title_search 	= answer.search('Title')
				doc_id_search = answer.search('DocID')

				title_text 	  = title_search.first.text 	if !title_search.empty?
				doc_id	   	  = doc_id_search.first.text.strip    if !doc_id_search.empty?


				@content = Content.find_by_title title_text.gsub(/\n/,"").gsub(/\t/,"")
				@content.mayo_doc_id = doc_id if !doc_id.nil?
				@content.save!
			end
		end
	end





	task :migrate_content_ids => :environment do

		UserReading.all.each do |ur|
			ur.update_attribute :content_id, ur.content.mayo_doc_id if ur.content && ur.content.mayo_doc_id
		end

		Message.all.each do |message|
			message.update_attribute :content_id, message.content.mayo_doc_id if message.content && message.content.mayo_doc_id
		end

		ContentsMayoVocabulary.all.each do |cmv|
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

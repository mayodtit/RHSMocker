#Import Answers Content from Mayo Into the database
require 'nokogiri'

namespace :admin do

	task :import_content=> :environment do
		Dir.glob('./db/mayo_content/*.xml') do | answerFile |

			print "."
			#puts "Found File: #{answerFile}"
			answer = Nokogiri::XML(open(answerFile))

			title_search 	= answer.search('Title')
			abstract_search = answer.search('Abstract')
			question_search = answer.search('Question')
			body_search		= answer.search('Body')
			keyword_search	= answer.search('MetaKeyword')
			type_search		= answer.search('Meta ContentType')
			update_search	= answer.search('UpdateDate')
			mayo_vocab_search = answer.search('Keyword')

			title_text 	  = title_search.first.text 	if !title_search.empty?
			abstract_text = abstract_search.first.text 	if !abstract_search.empty?
			question_text = question_search.first.text 	if !question_search.empty?
			body_text	  = body_search.first.text 		if !body_search.empty?
			type_text	  = type_search.first.text 		if !type_search.empty?
			update_text	  = update_search.first.text    if !update_search.empty?

			keywords = ''

			keyword_search.each do | keyword |
				keywords += keyword.text.gsub(/\n/,"").gsub(/\t/,"") + ','
			end


		 	@content = Content.new()

		 	@content.title 		= title_text.gsub(/\n/,"").gsub(/\t/,"") 		if !title_text.nil?
		 	@content.abstract 	= abstract_text.gsub(/\n/,"").gsub(/\t/,"") 	if !abstract_text.nil?
		 	@content.question 	= question_text.gsub(/\n/,"").gsub(/\t/,"") 	if !question_text.nil?
		 	@content.body 		= body_text.gsub(/\n/,"").gsub(/\t/,"") 		if !body_text.nil?
		 	@content.contentsType = type_text.gsub(/\n/,"").gsub(/\t/,"").titlecase if !type_text.nil?
		 	@content.updateDate = update_text.gsub(/\n/,"").gsub(/\t/,"") 		if !update_text.nil?
		 	@content.keywords 	= keywords
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
					ContentVocabulary.create(mayo_vocabulary:@mayoVocab, content:@content)
				end

			end

		end
	end
end

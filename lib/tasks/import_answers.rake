#Import Answers Content from Mayo Into the database
require 'nokogiri'

namespace :admin do

	task :import_content=> :environment do
		#puts Dir.pwd
		Dir.glob('./db/mayo_content/answers_xml/*.xml') do | answerFile |

			puts "Found File: #{answerFile}"
			#:title, :body, :author, :contentsType, :abstract, :question
			answer = Nokogiri::XML(open(answerFile))

			title_search 	= answer.search('Title')
			abstract_search = answer.search('Abstract')
			question_search = answer.search('Question')
			body_search		= answer.search('Body')
			keyword_search	= answer.search('MetaKeyword')

			title_text 	  = title_search.first.text 	if !title_search.empty?
			abstract_text = abstract_search.first.text 	if !abstract_search.empty?
			question_text = question_search.first.text 	if !question_search.empty?
			body_text	  = body_search.first.text 		if !body_search.empty?

			keywords = ''

			keyword_search.each do | keyword |
				keywords += keyword.text.gsub(/\n/,"").gsub(/\t/,"") + ','
			end


		 	@content = Content.new(
		 		:contentsType => 'answer'
				)

		 	@content.title 		= title_text.gsub(/\n/,"").gsub(/\t/,"") 		if !title_text.nil?
		 	@content.abstract 	= abstract_text.gsub(/\n/,"").gsub(/\t/,"") 	if !abstract_text.nil?
		 	@content.question 	=question_text.gsub(/\n/,"").gsub(/\t/,"") 		if !question_text.nil?
		 	@content.body 		= body_text.gsub(/\n/,"").gsub(/\t/,"") 		if !body_text.nil?
		 	@content.keywords 	= keywords
			@content.save!
		end
	end
end

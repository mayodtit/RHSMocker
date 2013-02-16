#Import Disease Content from Mayo Into the database
require 'nokogiri'

namespace :admin do

	task :import_disease => :environment do
		#puts Dir.pwd
		Dir.glob('./db/mayo_content/disease_xml/*.xml') do | diseaseFile |

			puts "Found File: #{diseaseFile}"
			#:title, :body, :author, :contentsType, :abstract, :question
			answer = Nokogiri::XML(open(diseaseFile))


			title_search 	= answer.search('Title')
			abstract_search = answer.search('Abstract')
			body_search		= answer.search('Body')

			title_text 	  = title_search.first.text 	if !title_search.empty?
			abstract_text = abstract_search.first.text 	if !abstract_search.empty?
			body_text	  = body_search.first.text 		if !body_search.empty?


		 	@content = Content.new(
		 		:contentsType => 'disease'
				)

		 	@content.title 		= title_text.gsub(/\n/,"").gsub(/\t/,"") 		if !title_text.nil?
		 	@content.abstract 	= abstract_text.gsub(/\n/,"").gsub(/\t/,"") 	if !abstract_text.nil?
		 	@content.body 		= body_text.gsub(/\n/,"").gsub(/\t/,"") 		if !body_text.nil?
			@content.save!
		end
	end
end
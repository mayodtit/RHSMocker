#Import Cinical Content from Mayo Into the database

namespace :admin do

	task :import_all_assets=> :environment do

		Content.destroy_all #ensure dependancies
		print "IMPORTING CONTENT ASSETS..."
		Rake::Task["admin:import_content"].invoke
		
	end
end

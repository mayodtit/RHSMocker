namespace :admin do
  task :backfill_provider_image_urls, [:execute] => :environment do |t, args|
    execute_arg = args[:execute] || "false"
    commit_changes = (execute_arg == "true")

    puts "DRY RUN - No database updates" unless commit_changes

    LookupProviderImages.do(commit_changes)
  end
end

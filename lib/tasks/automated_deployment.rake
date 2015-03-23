namespace :automated_deployment do
  task :deploy, [:build_id, :job_id] => :environment do |t, args|
    build_id = args[:build_id]
    job_id = args[:job_id]

    puts "Build: #{build_id}, Job: #{job_id}"
  end
end

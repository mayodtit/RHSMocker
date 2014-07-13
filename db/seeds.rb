%w(agreements
   allergies
   association_types
   conditions
   contents
   diets
   ethnic_groups
   messages
   roles
   service_types
   treatments).each do |filename|
     load File.join(Rails.root, 'db', 'seeds', "#{filename}.rb")
   end

if ENV['seed_users']
  load File.join(Rails.root, 'db', 'seeds', 'users.rb')
end

if ENV['seed_content']
  Rake::Task["admin:import_content"].execute
end

if ENV['seed_symptoms']
  Rake::Task["admin:import_symptoms"].execute
end

if ENV['seed_metadata']
  load File.join(Rails.root, 'db', 'seeds', 'metadata.rb')
end

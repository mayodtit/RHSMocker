%w(agreements
   allergies
   bmi_input_data
   domain
   association_types
   conditions
   contents
   diets
   ethnic_groups
   feature_flags
   hcp_taxonomy
   messages
   modal_templates
   premium_onboarding
   roles
   service_types
   user_requests
   treatments
   service_templates
   suggested_service_templates
   task_templates).each do |filename|
     load File.join(Rails.root, 'db', 'seeds', "#{filename}.rb")
   end

if ENV['seed_users'] || ENV['seed_fast'] || ENV['seed_all']
  load File.join(Rails.root, 'db', 'seeds', 'users.rb')
end

if ENV['seed_content'] || ENV['seed_all']
  Rake::Task["admin:import_content"].execute
end

if ENV['seed_symptoms'] || ENV['seed_all']
  Rake::Task["admin:import_symptoms"].execute
end

if ENV['seed_metadata'] || ENV['seed_fast'] ||  ENV['seed_all']
  load File.join(Rails.root, 'db', 'seeds', 'metadata.rb')
end

if ENV['seed_onboarding'] || ENV['seed_fast'] || ENV['seed_all']
  load File.join(Rails.root, 'db', 'seeds', 'onboarding.rb')
end

if ENV['seed_nux'] || ENV['seed_fast'] || ENV['seed_all']
  load File.join(Rails.root, 'db', 'seeds', 'nux.rb')
end

Content.reindex
Allergy.reindex
Condition.reindex
Treatment.reindex
Sunspot.commit

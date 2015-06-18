# Use find or create so that flags are not overriden
puts 'Seeding feature flags...'
[
  {key: 'attach_services_to_message', value: 'true', description: 'Allows the user to attach a service to a message'},
  {key: 'idle_timeout', value: 'true', description: 'Logs the user out after 10 minutes of being idle'},
  {key: 'add_task_to_service', value: 'true', description: 'Enables the user to add one off task to a service'},
  {key: 'add_family_member', value: 'false', description: 'Enables the user to add a new member to a family'}
].each do |hash|
  FeatureFlag.find_or_create_by_mkey!(mkey: hash[:key], mvalue: hash[:value], description: hash[:description])
end

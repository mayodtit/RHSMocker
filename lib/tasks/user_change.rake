namespace :user_change do
  desc "convert existing UserChange to YAML"
  task :serialize_to_yaml => :environment do
    UserChange.all.to_yaml
  end
end

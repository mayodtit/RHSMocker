namespace :db do
  desc 'Resets development and test databases, and then imports and seeds development database'
  task :reboot => [
    :check_if_development,
    :drop,
    :create,
    'db:schema:load',
    :seed,
    'seeds:care',
    'admin:import_content',
    'admin:import_symptoms',
    'admin:import_hcp_taxonomy',
    'db:test:prepare'
  ] do

  end

  task :check_if_development do
    unless Rails.env.development?
      puts 'Task can only be run in development environments'
      raise
    end
  end
end

namespace :db do
  desc 'Drops, recreates, loads, and seeds database'
  task :reboot => [:check_if_development, :drop, :create, 'db:schema:load', :seed] do

  end

  task :check_if_development do
    unless Rails.env.development?
      puts 'Task can only be run in development environments'
      raise
    end
  end
end
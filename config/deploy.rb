require "bundler/capistrano"
#require 'new_relic/recipes'
puts "   ======================================================"
puts "   Usage: cap <target> deploy [-s branch=<branch or tag>]"
puts "   ======================================================"


default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :application, "RHSMocker"
set :repository, "git@github.com:RemoteHealthServices/RHSMocker.git"
set :scm, :git
set :branch, "master"
set :user, "rhs"                   # The server's user for deploys
set :scm_verbose, true
set :deploy_via, :remote_cache
set :deploy_to, '/home/rhs/rails'
set :keep_releases, 12
#set :git_shallow_clone, 1
set :rails_env, "development"
set :use_sudo,  false

desc "Deploy target devhosted (goldenbear @ EC2)"
task :devhosted do
  set :port, 9722
  set :branch,    'develop'
  set :rails_env, 'devhosted'
  set :cron_file, 'cron-goldenbear'
  set :deploy_to, '/home/rhs/api-dev'
  role :web,      'goldenbear.getbetter.com'
  role :app,      'goldenbear.getbetter.com', :primary => true
  role :db,       'goldenbear.getbetter.com', :primary => true
#  role :delayed,  'goldenbear.getbetter.com'
  role :cron,     'goldenbear.getbetter.com'
  role :web,      'thunderbird.getbetter.com'
  role :app,      'thunderbird.getbetter.com'
  role :delayed,  'thunderbird.getbetter.com'
end

desc "Deploy target production @ FireHost (longhorn, wolverine)"
task :production do
  set :port, 22
  set :branch,    'master'
  set :rails_env, 'production'
  set :cron_file, 'cron-buckeye'
  set :deploy_to, '/home/rhs/rails'
  role :web,      'longhorn.getbetter.com'
  role :app,      'longhorn.getbetter.com', :primary => true
  role :web,      'wolverine.getbetter.com'
  role :web,      'buckeye.getbetter.com'
  role :app,      'buckeye.getbetter.com'
  role :db,       'longhorn.getbetter.com', :primary => true
  role :delayed,  'longhorn.getbetter.com'
  role :delayed,  'buckeye.getbetter.com'
  role :cron,     'buckeye.getbetter.com'
  role :web,      'spartan.getbetter.com'
  role :app,      'spartan.getbetter.com'
  role :delayed,  'spartan.getbetter.com'
end

desc "Deploy target qa (goldenbear @ EC2)"
task :qa do
  set :port, 9722
  set :branch,    'qa'
  set :rails_env, 'qa'
  set :cron_file, 'cron-goldenbear'
  set :deploy_to, '/home/rhs/api-qa'
  role :web,      'goldenbear.getbetter.com'
  role :app,      'goldenbear.getbetter.com', :primary => true
  role :db,       'goldenbear.getbetter.com', :primary => true
#  role :delayed,  'goldenbear.getbetter.com'
  role :cron,     'goldenbear.getbetter.com'
  role :web,      'thunderbird.getbetter.com'
  role :app,      'thunderbird.getbetter.com'
  role :delayed,  'thunderbird.getbetter.com'
end

desc "Deploy target demo (goldenbear @ EC2)"
task :demo do
  set :port, 9722
  set :branch,    'master'
  set :rails_env, 'demo'
  set :deploy_to, '/home/rhs/api-demo'
  set :cron_file, 'cron-goldenbear'
  role :web,      'goldenbear.getbetter.com'
  role :app,      'goldenbear.getbetter.com', :primary => true
  role :db,       'goldenbear.getbetter.com', :primary => true
#  role :delayed,  'goldenbear.getbetter.com'
  role :cron,     'goldenbear.getbetter.com'
  role :web,      'thunderbird.getbetter.com'
  role :app,      'thunderbird.getbetter.com'
  role :delayed,  'thunderbird.getbetter.com'
end

desc "Restart delayed_job"
task :restart_delayed_job, :roles => :delayed do
  run "sudo monit -g delayed_job restart all"
end

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :set_deploy_vars do
    if respond_to? :branch
      puts "---> DEPLOYING RELEASE: #{branch}"
      set :release_type, "tag"
      set :branch, "#{branch}"
    else
      puts "---> DEPLOYING RELEASE from HEAD"
      set :release_type, "master"
      set :branch, "master"
    end
  end

  namespace :web do
    task :disable, :roles => :web, :except => { :no_release => true } do
      on_rollback { run "rm -f #{shared_path}/system/maintenance.html"}
      #run "cp #{current_path}/public/maintenance.html #{shared_path}/system/maintenance.html"
      run "cp #{shared_path}/config/maintenance.html #{shared_path}/system/maintenance.html"
    end

    task :enable, :roles => :web, :except => { :no_release => true } do
      run "rm -f #{shared_path}/system/maintenance.html"
    end
  end

  task :fix_symlinks do
    %w(database.yml sunspot.yml application.yml).each do |f|
      run "rm -f #{release_path}/config/#{f} && ln -s #{shared_path}/config/#{f} #{release_path}/config/#{f}"
    end
    run "mkdir -p #{release_path}/config/static/ && rm -f #{release_path}/config/static/better.pem && ln -s #{shared_path}/config/better.pem #{release_path}/config/static/better.pem"
    run "git ls-remote git@github.com:RemoteHealthServices/RHSMocker.git #{branch} >> #{release_path}/public/VERSION.txt"
  end

  task :write_crontab, roles: :cron do
    run "crontab < #{release_path}/config/#{cron_file}"
  end

  task :run_seeds do
    run "cd #{release_path}; /usr/bin/env RAILS_ENV=#{rails_env} bundle exec rake db:seeds"
  end

  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end


task :complete do
  begin
    raise if ENV["SHUTUP_CAPISTRANO"]
    `say "cap deploy complete"`
  rescue Exception => e
    `say "I've just picked up a fault in the AE35 unit. It's going to go 100% failure in 72 hours"`
    puts "#{e} ... (ignoring)"
  end
  puts ">>>>>> DONE DEPLOYING <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
end

before "deploy:update_code", "deploy:set_deploy_vars"
after 'deploy:update_code', 'deploy:cleanup'

after("deploy:finalize_update", "deploy:fix_symlinks")
before "deploy:create_symlink", "deploy:web:disable"
after 'deploy', 'deploy:migrate'
after 'deploy:migrate', 'deploy:web:enable'
after 'deploy:migrate', 'deploy:write_crontab'
after 'deploy:migrate', 'deploy:run_seeds'
after 'deploy:web:enable', 'restart_delayed_job'
after 'deploy:web:enable', 'complete'

require './config/boot'
#require 'airbrake/capistrano'

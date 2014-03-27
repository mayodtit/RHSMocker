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
set :keep_releases, 5
#set :git_shallow_clone, 1
set :rails_env, "development"
set :use_sudo,  false

desc "Deploy target devhosted (goldenbear @ EC2)"
task :devhosted do
  set :port, 9722
  set :branch,    'develop'
  set :rails_env, 'devhosted'
  role :web,      'goldenbear.getbetter.com'
  role :app,      'goldenbear.getbetter.com', :primary => true
  role :db,       'goldenbear.getbetter.com', :primary => true
  role :delayed,  'goldenbear.getbetter.com'
end

#desc "Deploy target sandbox @ EC2"
#task :sandbox do
#  set :port, 9722
#  set :branch,    'develop'
#  set :rails_env, 'sandbox'
#  role :web,      'sandbox.getbetter.com'
#  role :app,      'sandbox.getbetter.com', :primary => true
#  role :db,       'sandbox.getbetter.com', :primary => true
#  role :delayed,  'sandbox.getbetter.com'
#end

desc "Deploy target production @ FireHost (longhorn, wolverine)"
task :production do
  set :port, 22
  set :branch,    'master'
  set :rails_env, 'production'
  role :web,      'longhorn.getbetter.com'
  role :app,      'longhorn.getbetter.com', :primary => true
  role :web,      'wolverine.getbetter.com'
  #role :app,      "wolverine.getbetter.com", :primary => true
  role :db,       'longhorn.getbetter.com', :primary => true
  role :delayed,  'longhorn.getbetter.com'
end

desc "Deploy target qaold @ FireHost (buckeye)"
task :qaold do
  set :port, 22
  set :branch,    'qa'
  set :rails_env, 'qa'
  set :deploy_to, '/home/rhs/qa'
  role :web,      'wolverine.getbetter.com'
  role :web,      'buckeye.getbetter.com'
  role :app,      'buckeye.getbetter.com', :primary => true
  role :db,       'buckeye.getbetter.com', :primary => true
  role :delayed,  'buckeye.getbetter.com'
end

desc "Deploy target qa (goldenbear @ EC2)"
task :qa do
  set :port, 9722
  set :branch,    'qa'
  set :rails_env, 'qa'
  set :deploy_to, '/home/rhs/qa'
  role :web,      'goldenbear.getbetter.com'
  role :app,      'goldenbear.getbetter.com', :primary => true
  role :db,       'goldenbear.getbetter.com', :primary => true
  role :delayed,  'goldenbear.getbetter.com'
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
#    if %w[production qa].include?(rails_env)
      run "mkdir -p #{release_path}/config/static/ && rm -f #{release_path}/config/static/better.pem && ln -s #{shared_path}/config/better.pem #{release_path}/config/static/better.pem"
#    end
    run "git ls-remote git@github.com:RemoteHealthServices/RHSMocker.git #{branch} >> #{release_path}/public/VERSION.txt"
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
after 'deploy:web:enable', 'restart_delayed_job'
after 'deploy:web:enable', 'complete'

require './config/boot'
#require 'airbrake/capistrano'

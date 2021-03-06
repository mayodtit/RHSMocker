require 'travis'

namespace :automated_deployment do
  task deploy: :environment do
    next unless deploy_target
    attempt_deploy!
  end

  def attempt_deploy!
    Travis::Pro.access_token = ENV['TRAVIS_ACCESS_TOKEN']
    attempts = 0
    while !jobs_failed? && attempts < 20 do
      deploy! and return if jobs_passed?
      puts 'Not yet ready to deploy, trying again in 30 seconds'
      attempts += 1
      sleep 30
    end
    puts 'Prerequisites not met, aborting automated deployment.'
  end

  def repo
    Travis::Pro::Repository.find('RemoteHealthServices/RHSMocker')
  end

  def build
    repo.build(ENV['TRAVIS_BUILD_NUMBER'])
  end

  def jobs
    build.jobs
  end

  def jobs_excluding_this_one
    begin
      jobs.reject{|j| j.number == ENV['TRAVIS_JOB_NUMBER']}
    rescue KeyError
      retry
    end
  end

  def jobs_passed?
    jobs_excluding_this_one.each do |job|
      return false unless job.passed?
    end
    true
  end

  def jobs_failed?
    jobs_excluding_this_one.each do |job|
      return true if job.failed?
    end
    false
  end

  def deploy_target
    case ENV['TRAVIS_BRANCH']
    when 'develop'
      'devhosted'
    when 'qa'
      'qa'
    else
      nil
    end
  end

  def develop?
    ENV['TRAVIS_BRANCH'] == 'develop'
  end

  def deploy!
    system("bundle exec cap #{deploy_target} deploy")
    system("bundle exec rake docs:generate api_docs:export S3_BUCKET=btr01-dev") if develop?
    true
  end
end

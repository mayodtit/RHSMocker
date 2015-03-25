require 'travis'

namespace :automated_deployment do
  task deploy: :environment do
    return unless deploy_target
    attempt_deploy!
  end

  def attempt_deploy!
    Travis::Pro.access_token = ENV['TRAVIS_ACCESS_TOKEN']
    attempts = 0
    while !jobs_failed? && attempts < 10 do
      deploy! and return if jobs_passed?
      puts 'Not yet ready to deploy, trying again in 30 seconds'
      attempts += 1
      sleep 30
    end
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

  def deploy!
    system("bundle exec cap #{deploy_target} deploy")
    true
  end
end

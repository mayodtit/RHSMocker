source 'https://rubygems.org'
#ruby '1.9.3'

gem 'rails', '3.2.18' # Caltrain
gem 'nokogiri'        # content parsing
gem 'newrelic_rpm'    # Monitoring
gem 'mysql2'          # db

#installing therubyracer, less-rails, and twitter-bootstrap-rails
gem 'therubyracer'
gem 'less-rails' #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'

# Site monitoring
gem 'fitter-happier'

# Mixpanel tracking
gem 'mixpanel-ruby'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'

  #datatables
  gem 'jquery-datatables-rails', github: 'rweng/jquery-datatables-rails'
  gem 'jquery-ui-rails'

end

group :development, :test do
  gem 'rspec_api_documentation'
  gem "rspec-rails", "~> 2.0"
  gem "parallel_tests"
  gem "zeus-parallel_tests"
  gem 'factory_girl_rails'
  gem 'guard-rspec'
  gem 'byebug'
end

group :development do
  gem 'capistrano', '~> 2.15'
  gem 'rest_client', require: false
end

group :test do
  gem 'stripe-ruby-mock', '~> 2.0.0'
  gem 'timecop'
end

gem 'codeclimate-test-reporter', group: :test, require: nil    # test coverage for Code Climate
gem 'raddocs', :git => 'git://github.com/chilcutt/raddocs.git' # gem for parsing API documentation JSON

gem 'jquery-rails'
gem 'factual-api'

#SOLR Support
gem 'sunspot_rails'
gem 'sunspot_solr'
gem 'progress_bar' #for indexing

gem "rails_config"
gem 'sorcery'
gem 'cancan'
gem "active_model_serializers"

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

gem 'httparty'
gem 'awesome_print'
gem 'titleize'
gem 'haml'
gem 'state_machine'
gem 'daemons'	# To run backgound jobs
gem 'delayed_job_active_record' # background jobs
gem 'figaro'
gem 'carrierwave'               # image storage
gem "carrierwave_encrypter_decrypter"
gem 'stripe'                    # payment processing
gem 'curb'                      # curl - used mainly for POSTing data to Google Analytics
gem 'minitar'
gem 'fog'                       # cloud storage
gem 's3_uploader'               # uploading things to, uh, s3
gem 'ri_cal'
gem 'symbolize'
gem 'kaminari' # pagination
gem 'strong_parameters'
gem 'rubyzip'
gem 'twilio-ruby'
gem 'mandrill_mailer'           # for integration with MailChimp templates
gem 'apns'
gem 'base32-crockford'
gem 'state_machine-audit_trail'
gem 'business_time'
gem 'test_after_commit', '~> 0.3.0', group: :test
gem 'spawnling', '2.1.1'
gem 'stripe_event'
gem 'roo'
gem 'mail'
gem 'mailcheck'
gem 'valid_email', require: 'valid_email/validate_email'       # library for email validation
gem 'travis', require: false
gem 'acts_as_commentable', '3.0.1'

source 'https://rubygems.org'
#ruby '1.9.3'

gem 'rails', '3.2.14'
#content parsing
gem 'nokogiri'
gem 'pg' # This needs to come after Nokogiri https://github.com/sparklemotion/nokogiri/issues/742

#static security scanner
#gem 'brakeman' #http://brakemanscanner.org/

#Monitoring
gem 'newrelic_rpm'

#installing therubyracer, less-rails, and twitter-bootstrap-rails
gem 'therubyracer'
gem 'less-rails' #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'

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
  gem 'capybara'
  gem 'guard-rspec'
  gem 'simplecov'
end

# test coverage for Code Climate
gem 'codeclimate-test-reporter', group: :test, require: nil

gem 'raddocs', :git => 'git://github.com/chilcutt/raddocs.git'

gem 'jquery-rails'
gem 'pusher'
gem 'factual-api'
gem 'rufus-scheduler'



#SOLR Support
gem 'sunspot_rails'
gem 'sunspot_solr'
gem 'progress_bar' #for indexing

#Remove before MVP
gem 'lorem-ipsum-me'

gem "rails_config"


gem 'sorcery'

gem 'cancan'

gem "rolify",        :git => "git://github.com/EppO/rolify.git"


gem "active_model_serializers", "~> 0.7.0"

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

gem 'httparty'
gem 'debugger'
gem 'awesome_print'
gem 'titleize'
gem 'haml'
gem 'state_machine'
gem 'delayed_job_active_record'
gem 'figaro'
gem 'stripe'

gem 'curb'
gem 'minitar'
gem 'fog'
gem 's3_uploader'

# Used for rails_stdout_logging and rails_serve_static_assets
gem 'rails_12factor', group: :production

gem 'ri_cal'
gem 'symbolize'

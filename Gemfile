source 'https://rubygems.org'

gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :development do
  gem 'sqlite3'
  #gem 'pg'
end

group :production do
  gem 'pg'
end

#static security scanner
#http://brakemanscanner.org/
gem 'brakeman'

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

gem 'jquery-rails'
gem 'pusher'
gem 'factual-api'
gem 'rufus-scheduler'

#content parsing
gem 'nokogiri'

#SOLR Support
gem 'sunspot_rails'
gem 'sunspot_solr'
gem 'progress_bar' #for indexing

#Remove before MVP
gem 'lorem-ipsum-me'



# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

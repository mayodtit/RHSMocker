RHSMocker::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  # config.action_mailer.raise_delivery_errors = false

  # Set Mailer Host
  config.action_mailer.perform_deliveries = true

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.delivery_method = :file
  config.action_mailer.file_settings = { :location => 'tmp/mails' }

  # Mandrill devlocal test key.  Emails will be passed to Mandrill but will
  # not be delivered.  Uncomment out the below section to deliver emails.
  MandrillMailer.configure { |config| config.api_key = 'ggndKBJ29Mu5W9sEXd3ixQ' }

  # *** HEY BOSS. BE CAREFUL HERE *********************************************
  # uncomment to send live emails
  key = 'pyRbUi-5ZA55IVKSbWYpfw'
  config.action_mailer.smtp_settings = {
  :address              => 'smtp.mandrillapp.com',
  :port                 => 587,
  :domain               => 'api-dev.getbetter.com',
  :user_name            => 'engineering@getbetter.com',
  :password             => key,
  :authentication       => :plain,
  :enable_starttls_auto => true
  }
  config.action_mailer.delivery_method = :smtp

  MandrillMailer.configure { |config| config.api_key = key }

  MandrillMailer.configure do |config|
    config.interceptor_params = { to: [{ email: "engineering@better.com", name: "test" }] }
  end
  # ***************************************************************************

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.after_initialize do
    Rails.application.routes.default_url_options[:protocol] = 'http'
    Rails.application.routes.default_url_options[:host] = ENV['TWILIO_ENDPOINT_HOST'] || 'localhost:3000'
  end

  config.colorize_logging = false
end

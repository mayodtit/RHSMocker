RHSMocker::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Heroku REQUIRES this to be false
  config.assets.initialize_on_precompile = false

  # Include any files that you want to link to directly from your templates directly.
  config.assets.precompile += ['application.css', 'application.js']

  # Not required, but a good best-practice for performance.
  # This setting will compress your assets as much as possible using YUI and Uglifier by default
  config.assets.compress = true

  # Allow fingerprinting of asset filenames - good for caching.
  config.assets.digest = true

  # Configure the sendfile headers for Heroku.  "X-Accel-Redirect" is also a good value for this since Heroku use Nginx.
  config.action_dispatch.x_sendfile_header = nil

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = true



  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false



  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Set Mailer Host
  config.action_mailer.perform_deliveries = true

  config.action_mailer.default_url_options = { :host => 'rhs-qa.herokuapp.com' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => "smtp.sendgrid.net",
    :port                 => 587,
    :domain               => 'rhs-qa.herokuapp.com',
    :user_name            => 'better_eng',
    :password             => 'better120',
    :authentication       => :plain,
    :enable_starttls_auto => true
  }

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
end

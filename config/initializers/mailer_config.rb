require 'non_production_mail_interceptor'
ActionMailer::Base.register_interceptor(NonProductionMailInterceptor) unless (Rails.env.production? || Rails.env.demo?)


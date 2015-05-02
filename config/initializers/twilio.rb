TWILIO_SID = ENV['TWILIO_SID'] || 'ACc330c267edd990e4538ce9c4fcf850f5'
TWILIO_TOKEN = ENV['TWILIO_TOKEN'] || 'f0c071c8c12a4aea9c2c4b7d0ca8ad1b'
TWILIO_WAIT_URL = 'http://twimlets.com/holdmusic?Bucket=com.twilio.music.soft-rock'
PHA_PHONE_NUMBER = '8553363629'
NURSE_PHONE_NUMBER = '8554733230'
DIRECT_NURSE_PHONE_NUMBER = '4158002865'
URL_HELPERS = Rails.application.routes.url_helpers
SERVICE_ALERT_PHONE_NUMBER = '6508521094'
OUTBOUND_CALLS_NUMBER = '6503196129'

folder = ''
if Rails.env.qa?
  folder = '-qa'
elsif Rails.env.devhosted? || Rails.env.development?
  folder = '-dev'
end
TWILIO_SOUNDS_URL_PREFIX = "https://s3-us-west-2.amazonaws.com/btr-static#{folder}/phone"

require 'twilio_module'
include TwilioModule

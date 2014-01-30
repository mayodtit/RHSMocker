require 'utils/phone_number_util'
TWILIO_SID = ENV['TWILIO_SID'] || 'ACc330c267edd990e4538ce9c4fcf850f5'
TWILIO_TOKEN = ENV['TWILIO_TOKEN'] || 'f0c071c8c12a4aea9c2c4b7d0ca8ad1b'
TWILIO_WAIT_URL = 'http://twimlets.com/holdmusic?Bucket=com.twilio.music.soft-rock'
PHA_NUMBER = ENV['PHA_NUMBER'] || '4154232887'
NURSELINE_NUMBER = ENV['NURSELINE_NUMBER'] || '4083913578'
URL_HELPERS = Rails.application.routes.url_helpers
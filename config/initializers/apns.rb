APNS.host = ENV['APNS_HOST']
APNS.port = ENV['APNS_PORT'].try(:to_i) || 2195
APNS.pem = "#{Rails.root}/#{ENV['APNS_PEM_PATH']}"
APNS.pass = ENV['APNS_PEM_PASSPHRASE']

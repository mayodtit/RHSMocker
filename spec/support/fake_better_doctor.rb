require 'sinatra/base'

## http://robots.thoughtbot.com/how-to-stub-external-services-in-tests

class FakeBetterDoctor < Sinatra::Base
  get '/beta/doctors/npi/1285699967' do
    json_response 200, 'doctor_npi.json'
  end

  get '/beta/doctors/npi/0000000404' do
    json_response 404, 'doctor_npi_not_found.json'
  end

  get '/beta/doctors/npi/0000000401' do
    json_response 401, 'error_invalid_user_key.json'
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end

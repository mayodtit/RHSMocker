require 'sinatra/base'

## http://robots.thoughtbot.com/how-to-stub-external-services-in-tests

class FakeBloom < Sinatra::Base
  get '/api/search' do
    json_response 200, 'providers.json'
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
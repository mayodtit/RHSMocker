require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'RemoteEvents' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  post '/api/v1/remote_events' do
    parameter :auth_token, 'Performing user auth_token'
    parameter :device_model, 'the device used eg. Simulator'
    parameter :device_os, 'the OS of the device'
    parameter :app_version, 'the version of current app, eg. 1.2'
    parameter :device_language, 'the language used on device'
    parameter :device_os_version, 'the version of the OS running on device'
    parameter :app_build, 'the number of build, eg. 11019'
    parameter :device_id, 'id of the device '
    parameter :device_timezone_offset, 'local timezone offset with UTC'
    parameter :device_timezone, 'time zone of the device in'
    parameter :device_user_id, 'user id of the device'
    parameter :name, 'name of the event'
    parameter :category, 'category of the event'
    parameter :created_at, "integer second timestamp"
    scope_parameters :properties, [:device_model, :device_os, :app_version, :device_language, :device_os_version,
                                   :app_build, :device_id, :device_timezone_offset, :device_timezone, :device_user_id]
    scope_parameters :events, [:name, :category, :created_at]

    let!(:user){create(:member)}
    let(:session){user.sessions.create}
    let(:auth_token) {session.auth_token}
    let(:device_model){"Simulator"}
    let(:device_id){"A868F098-33CE-472E-AE8D-AD80098E600D"}
    let(:name){"test_name"}
    let(:raw_post) {params.to_json}

    example_request '[POST] Create a remote_event' do
      explanation 'Creates a new remote_event'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      expect(body[:remote_event][:device_id]).to eq(device_id)
      expect(body[:remote_event][:user_id]).to eq(user.id)
    end
  end
end
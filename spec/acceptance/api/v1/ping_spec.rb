require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Ping" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  get '/api/v1/ping' do
    let!(:phone_metadata) { create(:metadata, :mkey => 'phone_number', :mvalue => '5555555555') }
    let!(:version_metadata) { create(:metadata, :mkey => 'current_version', :mvalue => '5000') }
    let(:version) { '1.0.2' }

    parameter :version, 'client version'

    example_request "[GET] Ping the backend" do
      explanation "Ping the backend while unauthenticated"
      status.should == 200
      json = JSON.parse(response_body, :symbolize_names => true)
      json.should have_key(:revision)
      json.should_not have_key(:metadata)
    end

    context 'with an auth_token' do
      let!(:user) { create(:member) }
      let(:auth_token) { user.auth_token }

      parameter :auth_token, "Performing user's auth_token"

      example_request "[GET] Get application metadata" do
        explanation "Get authenticated metadata from the backend"
        status.should == 200
        json = JSON.parse(response_body, :symbolize_names => true)
        json[:metadata][phone_metadata.mkey.to_sym].should == phone_metadata.mvalue
        json[:metadata][version_metadata.mkey.to_sym].should == version_metadata.mvalue
        json.should have_key(:revision)
      end
    end
  end
end

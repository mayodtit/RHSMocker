require 'spec_helper'

describe 'WaitlistEntry' do
  describe 'POST /api/v1/waitlist_entries' do
    def do_request(params={})
      post "/api/v1/waitlist_entries", params
    end

    let(:email) { 'email@test.getbetter.com' }
    let(:attributes) { {:email => email} }

    it 'creates a new waitlist_entry' do
      expect{ do_request(:waitlist_entry => attributes) }.to change(WaitlistEntry, :count).by(1)
      response.should be_success
      body = JSON.parse(response.body, :symbolize_names => true)
      body[:waitlist_entry][:email].to_json.should == attributes[:email].to_json
    end
  end
end


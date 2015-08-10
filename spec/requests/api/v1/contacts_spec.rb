require 'spec_helper'

describe 'Contacts' do
  let!(:user) { create(:member) }
  let!(:session) { user.sessions.create }

  describe 'GET /api/v1/contacts' do
    def do_request
      get "/api/v1/contacts", auth_token: session.auth_token
    end

    def protocol
      Rails.application.routes.default_url_options[:protocol]
    end

    def host
      Rails.application.routes.default_url_options[:host]
    end

    def root_url
      if protocol && host
        protocol + '://' + host
      else
        ''
      end
    end

    let(:contacts_list) do
      [
        {
          name: 'Better PHA',
          phone: PHA_PHONE_NUMBER,
          status: 'online',
          image_url: root_url + ActionController::Base.helpers.asset_path('Contacts-PHA@2x.png'),
          show_border: false
        }
      ]
    end

    before do
      Role.stub_chain(:pha, :on_call?).and_return(true)
    end

    it 'indexes contacts' do
      do_request
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:contacts]).to eq(contacts_list)
    end
  end
end

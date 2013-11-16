require 'spec_helper'

describe 'CustomCards' do
  let(:user) { create(:member) }

  context 'existing record' do
    let!(:custom_card) { create(:custom_card) }

    describe 'GET /api/v1/custom_cards' do
      def do_request
        get '/api/v1/custom_cards', auth_token: user.auth_token
      end

      it 'indexes custom_cards' do
        do_request
        response.should be_success
        body = JSON.parse(response.body, symbolize_names: true)
        body[:custom_cards].to_json.should == [custom_card].serializer.as_json.to_json
      end
    end

    describe 'GET /api/v1/custom_cards/:id' do
      def do_request
        get "/api/v1/custom_cards/#{custom_card.id}", auth_token: user.auth_token
      end

      it 'shows the custom_card' do
        do_request
        response.should be_success
        body = JSON.parse(response.body, symbolize_names: true)
        body[:custom_card].to_json.should == custom_card.serializer(preview: true, raw_preview: true).as_json.to_json
      end
    end

    describe 'PUT /api/v1/custom_cards/:id' do
      def do_request(params={})
        put "/api/v1/custom_cards/#{custom_card.id}", params.merge!(auth_token: user.auth_token)
      end

      let(:new_title) { 'new title' }

      it 'updates the custom_card' do
        do_request(custom_card: {title: new_title})
        response.should be_success
        body = JSON.parse(response.body, symbolize_names: true)
        custom_card.reload.title.should == new_title
        body[:custom_card].to_json.should == custom_card.serializer(preview: true, raw_preview: true).as_json.to_json
      end
    end
  end

  describe 'POST /api/v1/custom_cards' do
    def do_request(params={})
      post '/api/v1/custom_cards', params.merge!(auth_token: user.auth_token)
    end

    let(:custom_card_attributes) { attributes_for(:custom_card) }

    it 'creates a custom_card' do
      expect{ do_request(custom_card: custom_card_attributes) }.to change(CustomCard, :count).by(1)
      response.should be_success
      body = JSON.parse(response.body, symbolize_names: true)
      body[:custom_card][:title].should == custom_card_attributes[:title]
    end
  end
end

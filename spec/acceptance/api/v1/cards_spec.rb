require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Cards' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let(:auth_token) { user.auth_token }
  let(:user_id) { user.id }

  before(:each) do
    user.login
  end

  parameter :user_id, "Target user's ID"
  parameter :auth_token, "User's auth_token"
  required_parameters :auth_token, :user_id

  context 'with many cards' do
    let!(:unread_card) { create(:card, :user => user) }
    let!(:read_card) { create(:card, :read, :user => user) }
    let!(:saved_card) { create(:card, :saved, :user => user) }

    get '/api/v1/users/:user_id/cards' do
      example_request "[GET] Get all cards for a user" do
        explanation "Retreive all non-dismissed cards"
        status.should == 200
        json = JSON.parse(response_body, :symbolize_names => true)
        json[:cards].map{|c| c[:id]}.should include(unread_card.id, read_card.id, saved_card.id)
      end
    end

    get '/api/v1/users/:user_id/cards/inbox' do
      example_request "[GET] Get inbox cards for a user" do
        explanation "Retreive all inbox cards"
        status.should == 200
        json = JSON.parse(response_body, :symbolize_names => true)
        json[:cards].map{|c| c[:id]}.should include(unread_card.id, read_card.id)
      end
    end

    get '/api/v1/users/:user_id/cards/timeline' do
      example_request "[GET] Get timeline cards for a user" do
        explanation "Retreive all timeline cards"
        status.should == 200
        json = JSON.parse(response_body, :symbolize_names => true)
        json[:cards].map{|c| c[:id]}.should include(saved_card.id)
      end
    end
  end

  context 'member routes' do
    let!(:card) { create(:card, :user => user) }
    let(:id) { card.id }

    parameter :id, "Card ID"
    required_parameters :id

    get '/api/v1/users/:user_id/cards/:id' do
      example_request "[GET] Get single card for user" do
        explanation "Retreive a single Card"
        status.should == 200
        JSON.parse(response_body)['card'].should be_a Hash
      end
    end

    put '/api/v1/users/:user_id/cards/:id' do
      parameter :state_event, 'Card event, one of ["read", "saved", "dismissed"]'
      parameter :state_changed_at, 'Change timestamp, required when making a state transition'

      scope_parameters :card, [:state_event, :state_changed_at]

      let(:state_event) { 'saved' }
      let(:state_changed_at) { Time.now }
      let(:raw_post) { params.to_json }

      example_request "[PUT] Update single card for user" do
        explanation "Update a single Card"
        status.should == 200
        JSON.parse(response_body)['card'].should be_a Hash
      end
    end
  end
end

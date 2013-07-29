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

  get '/api/v1/users/:user_id/cards' do
    let!(:unread_card) { create(:card, :user => user) }
    let!(:read_card) { create(:card, :read, :user => user) }
    let!(:saved_card) { create(:card, :saved, :user => user) }

    example_request "[GET] Get cards for a user" do
      explanation "Retreive cards by status"
      status.should == 200
      JSON.parse(response_body)['cards'].should be_a Hash
    end

    context 'with type parameter' do
      parameter :type, 'Filter type for index action, one of ["carousel", "timeline"]'

      let(:type) { 'carousel' }

      example_request "[GET] Get cards for a user by type" do
        explanation "Retreive cards by status"
        status.should == 200
        JSON.parse(response_body)['cards'].should be_a Array
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
      parameter :read_at, 'Read timestamp, required for "read" state event'
      parameter :saved_at, 'Saved timestamp, required for "saved" state event'
      parameter :dismissed_at, 'Dismissed timestamp, required for "dismissed" state event'

      scope_parameters :card, [:state_event, :read_at, :saved_at, :dismissed_at]

      let(:state_event) { 'saved' }
      let(:saved_at) { Time.now }
      let(:raw_post) { params.to_json }

      example_request "[PUT] Update single card for user" do
        explanation "Update a single Card"
        status.should == 200
        JSON.parse(response_body)['card'].should be_a Hash
      end
    end
  end
end

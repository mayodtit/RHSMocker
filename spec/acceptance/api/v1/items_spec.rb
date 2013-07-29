require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Items' do
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

  get '/api/v1/users/:user_id/items' do
    let!(:unread_item) { create(:item, :user => user) }
    let!(:read_item) { create(:item, :read, :user => user) }
    let!(:saved_item) { create(:item, :saved, :user => user) }

    example_request "[GET] Get items for a user" do
      explanation "Retreive items by status"
      status.should == 200
      JSON.parse(response_body)['items'].should be_a Hash
    end

    context 'with type parameter' do
      parameter :type, 'Filter type for index action, one of ["carousel", "timeline"]'

      let(:type) { 'carousel' }

      example_request "[GET] Get items for a user by type" do
        explanation "Retreive items by status"
        status.should == 200
        JSON.parse(response_body)['items'].should be_a Array
      end
    end
  end

  context 'member routes' do
    let!(:item) { create(:item, :user => user) }
    let(:id) { item.id }

    parameter :id, "Item ID"
    required_parameters :id

    get '/api/v1/users/:user_id/items/:id' do
      example_request "[GET] Get single item for user" do
        explanation "Retreive a single Item"
        status.should == 200
        JSON.parse(response_body)['item'].should be_a Hash
      end
    end

    put '/api/v1/users/:user_id/items/:id' do
      parameter :state_event, 'Item event, one of ["read", "saved", "dismissed"]'
      parameter :read_at, 'Read timestamp, required for "read" state event'
      parameter :saved_at, 'Saved timestamp, required for "saved" state event'
      parameter :dismissed_at, 'Dismissed timestamp, required for "dismissed" state event'

      scope_parameters :item, [:state_event, :read_at, :saved_at, :dismissed_at]

      let(:state_event) { 'saved' }
      let(:saved_at) { Time.now }
      let(:raw_post) { params.to_json }

      example_request "[PUT] Update single item for user" do
        explanation "Update a single Item"
        status.should == 200
        JSON.parse(response_body)['item'].should be_a Hash
      end
    end
  end
end

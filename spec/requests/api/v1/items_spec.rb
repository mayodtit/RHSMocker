require 'spec_helper'

describe 'Items' do
  let(:user) { create(:member) }

  before(:each) do
    user.login
  end

  describe 'GET /api/v1/users/:user_id/items' do
    def do_request(params={})
      get "/api/v1/users/#{user.id}/items", params.merge!(auth_token: user.auth_token)
    end

    let!(:unread_item) { create(:item, :user => user) }
    let!(:read_item) { create(:item, :read, :user => user) }
    let!(:saved_item) { create(:item, :saved, :user => user) }
    let!(:dismissed_item) { create(:item, :dismissed, :user => user) }

    it 'indexes the user\'s items' do
      do_request
      response.should be_success
      body = JSON.parse(response.body, :symbolize_names => true)
      ids = body[:items].map{|item| item[:id]}
      ids.should include(unread_item.id, read_item.id, saved_item.id)
      ids.should_not include(dismissed_item.id)
    end

    describe 'carousel' do
      it 'indexes only carousel items' do
        do_request(type: :carousel)
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        ids = body[:items].map{|item| item[:id]}
        ids.should include(unread_item.id, read_item.id)
        ids.should_not include(saved_item.id, dismissed_item.id)
      end
    end

    describe 'timeline' do
      it 'indexes only timeline items' do
        do_request(type: :timeline)
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        ids = body[:items].map{|item| item[:id]}
        ids.should include(saved_item.id)
        ids.should_not include(unread_item.id, read_item.id, dismissed_item.id)
      end
    end
  end

  describe 'GET /api/v1/users/:user_id/items/:id' do
    def do_request
      get "/api/v1/users/#{user.id}/items/#{item.id}", auth_token: user.auth_token
    end

    let!(:item) { create(:item, :user => user) }

    it 'retrieves the item' do
      do_request
      response.should be_success
      body = JSON.parse(response.body, :symbolize_names => true)
      body[:item].to_json.should == item.as_json.to_json
    end
  end

  describe 'PUT /api/v1/users/:user_id/items/:id' do
    def do_request(params={})
      put "/api/v1/users/#{user.id}/items/#{item.id}", params.merge!(auth_token: user.auth_token)
    end

    let(:unread_item) { create(:item, :user => user) }
    let(:read_item) { create(:item, :read, :user => user) }
    let(:saved_item) { create(:item, :saved, :user => user) }
    let(:dismissed_item) { create(:item, :dismissed, :user => user) }

    describe 'mark read' do
      let(:attributes) { {:item => {:state_event => :read}} }

      context 'unread item' do
        let!(:item) { unread_item }

        it 'marks read' do
          do_request(attributes)
          response.should be_success
          item.reload.should be_read
        end
      end

      context 'read item' do
        let!(:item) { read_item }

        it 'is ignored' do
          do_request(attributes)
          response.should be_success
          item.reload.should be_read
        end
      end

      context 'saved item' do
        let!(:item) { saved_item }

        it 'is ignored' do
          do_request(attributes)
          response.should be_success
          item.reload.should be_saved
        end
      end

      context 'dismissed item' do
        let!(:item) { dismissed_item }

        it 'is ignored' do
          item = dismissed_item
          do_request(attributes)
          response.should be_success
          item.reload.should be_dismissed
        end
      end
    end

    describe 'mark saved' do
      let(:attributes) { {:item => {:state_event => :saved}} }

      context 'unread item' do
        let!(:item) { unread_item }

        it 'marks saved' do
          do_request(attributes)
          response.should be_success
          item.reload.should be_saved
        end
      end

      context 'read item' do
        let!(:item) { read_item }

        it 'marks saved' do
          do_request(attributes)
          response.should be_success
          item.reload.should be_saved
        end
      end

      context 'saved item' do
        let!(:item) { saved_item }

        it 'marks saved' do
          do_request(attributes)
          response.should be_success
          item.reload.should be_saved
        end
      end

      context 'dismissed item' do
        let!(:item) { dismissed_item }

        it 'marks saved' do
          do_request(attributes)
          response.should be_success
          item.reload.should be_saved
        end
      end
    end

    describe 'mark dismissed' do
      let(:attributes) { {:item => {:state_event => :dismissed}} }

      context 'unread item' do
        let!(:item) { unread_item }

        it 'marks dismissed' do
          do_request(attributes)
          response.should be_success
          item.reload.should be_dismissed
        end
      end

      context 'read item' do
        let!(:item) { read_item }

        it 'marks dismissed' do
          do_request(attributes)
          response.should be_success
          item.reload.should be_dismissed
        end
      end

      context 'saved item' do
        let!(:item) { saved_item }

        it 'marks dismissed' do
          do_request(attributes)
          response.should be_success
          item.reload.should be_dismissed
        end
      end

      context 'dismissed item' do
        let!(:item) { dismissed_item }

        it 'marks dismissed' do
          item = dismissed_item
          do_request(attributes)
          response.should be_success
          item.reload.should be_dismissed
        end
      end
    end
  end
end

require 'spec_helper'

describe 'Cards' do
  let(:user) { create(:member) }

  before(:each) do
    user.login
  end

  describe 'index methods' do
    let!(:unread_card) { create(:card, :user => user) }
    let!(:read_card) { create(:card, :read, :user => user) }
    let!(:saved_card) { create(:card, :saved, :user => user) }
    let!(:dismissed_card) { create(:card, :dismissed, :user => user) }

    describe 'GET /api/v1/users/:user_id/cards/inbox' do
      def do_request
        get "/api/v1/users/#{user.id}/cards/inbox", auth_token: user.auth_token
      end

      it 'indexes only carousel cards' do
        do_request
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        ids = body[:cards].map{|card| card[:id]}
        ids.should include(unread_card.id, read_card.id)
        ids.should_not include(saved_card.id, dismissed_card.id)
      end
    end

    describe 'GET /api/v1/users/:user_id/cards/timeline' do
      def do_request
        get "/api/v1/users/#{user.id}/cards/timeline", auth_token: user.auth_token
      end

      it 'indexes only timeline cards' do
        do_request
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        ids = body[:cards].map{|card| card[:id]}
        ids.should include(saved_card.id)
        ids.should_not include(unread_card.id, read_card.id, dismissed_card.id)
      end
    end
  end

  describe 'GET /api/v1/users/:user_id/cards/:id' do
    def do_request
      get "/api/v1/users/#{user.id}/cards/#{card.id}", auth_token: user.auth_token
    end

    let!(:card) { create(:card, :user => user) }

    it 'retrieves the card' do
      do_request
      response.should be_success
      body = JSON.parse(response.body, :symbolize_names => true)
      body[:card][:body].should_not be_nil
      body[:card].tap{|c| c.delete(:body)}.to_json.should == card.active_model_serializer_instance.as_json.to_json
    end
  end

  describe 'PUT /api/v1/users/:user_id/cards/:id' do
    def do_request(params={})
      put "/api/v1/users/#{user.id}/cards/#{card.id}", params.merge!(auth_token: user.auth_token)
    end

    let(:unread_card) { create(:card, :user => user) }
    let(:read_card) { create(:card, :read, :user => user) }
    let(:saved_card) { create(:card, :saved, :user => user) }
    let(:dismissed_card) { create(:card, :dismissed, :user => user) }

    describe 'mark read' do
      let(:attributes) { {:card => {:state_event => :read, :state_changed_at => Time.now}} }

      context 'unread card' do
        let!(:card) { unread_card }

        it 'marks read' do
          do_request(attributes)
          response.should be_success
          card.reload.should be_read
        end
      end

      context 'read card' do
        let!(:card) { read_card }

        it 'is ignored' do
          do_request(attributes)
          response.should be_success
          card.reload.should be_read
        end
      end

      context 'saved card' do
        let!(:card) { saved_card }

        it 'is ignored' do
          do_request(attributes)
          response.should be_success
          card.reload.should be_saved
        end
      end

      context 'dismissed card' do
        let!(:card) { dismissed_card }

        it 'is ignored' do
          card = dismissed_card
          do_request(attributes)
          response.should be_success
          card.reload.should be_dismissed
        end
      end
    end

    describe 'mark saved' do
      let(:attributes) { {:card => {:state_event => :saved, :state_changed_at => Time.now}} }

      context 'unread card' do
        let!(:card) { unread_card }

        it 'marks saved' do
          do_request(attributes)
          response.should be_success
          card.reload.should be_saved
        end
      end

      context 'read card' do
        let!(:card) { read_card }

        it 'marks saved' do
          do_request(attributes)
          response.should be_success
          card.reload.should be_saved
        end
      end

      context 'saved card' do
        let!(:card) { saved_card }

        it 'marks saved' do
          do_request(attributes)
          response.should be_success
          card.reload.should be_saved
        end
      end

      context 'dismissed card' do
        let!(:card) { dismissed_card }

        it 'marks saved' do
          do_request(attributes)
          response.should be_success
          card.reload.should be_saved
        end
      end
    end

    describe 'mark dismissed' do
      let(:attributes) { {:card => {:state_event => :dismissed, :state_changed_at => Time.now}} }

      context 'unread card' do
        let!(:card) { unread_card }

        it 'marks dismissed' do
          do_request(attributes)
          response.should be_success
          card.reload.should be_dismissed
        end
      end

      context 'read card' do
        let!(:card) { read_card }

        it 'marks dismissed' do
          do_request(attributes)
          response.should be_success
          card.reload.should be_dismissed
        end
      end

      context 'saved card' do
        let!(:card) { saved_card }

        it 'marks dismissed' do
          do_request(attributes)
          response.should be_success
          card.reload.should be_dismissed
        end
      end

      context 'dismissed card' do
        let!(:card) { dismissed_card }

        it 'marks dismissed' do
          card = dismissed_card
          do_request(attributes)
          response.should be_success
          card.reload.should be_dismissed
        end
      end
    end
  end
end

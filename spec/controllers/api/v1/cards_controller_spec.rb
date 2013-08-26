require 'spec_helper'

describe Api::V1::CardsController do
  let(:user) { build_stubbed(:member) }
  let(:ability) { Object.new.extend(CanCan::Ability) }
  let(:card) { build_stubbed(:card, :user => user) }
  let(:card_keys) { card.as_json.keys.map(&:to_sym) << :preview }

  before(:each) do
    controller.stub(:current_ability => ability)
  end

  describe 'GET index' do
    def do_request
      get :index
    end

    it_behaves_like 'action requiring authentication and authorization'
    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      let(:cards) { double('cards', :not_dismissed => [card]) }

      before(:each) do
        user.stub(:cards => cards)
      end

      it_behaves_like 'success'

      it 'returns a hash of cards by type' do
        do_request
        json = JSON.parse(response.body, :symbolize_names => true)
        json[:cards].first.keys.should =~ card_keys
      end
    end
  end

  describe 'GET inbox' do
    def do_request
      get :inbox
    end

    it_behaves_like 'action requiring authentication and authorization'
    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      let(:cards) { double('cards', :inbox => [card]) }

      before(:each) do
        user.stub(:cards => cards)
      end

      it_behaves_like 'success'

      it 'returns a hash of cards by type' do
        do_request
        json = JSON.parse(response.body, :symbolize_names => true)
        json[:cards].first.keys.should =~ card_keys
      end
    end
  end

  describe 'GET timeline' do
    def do_request
      get :timeline
    end

    it_behaves_like 'action requiring authentication and authorization'
    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      let(:cards) { double('cards', :timeline => [card]) }

      before(:each) do
        user.stub(:cards => cards)
      end

      it_behaves_like 'success'

      it 'returns a hash of cards by type' do
        do_request
        json = JSON.parse(response.body, :symbolize_names => true)
        json[:cards].first.keys.should =~ card_keys
      end
    end
  end

  describe 'GET show' do
    def do_request
      get :show
    end

    let(:cards) { double('cards', :find => card) }

    before(:each) do
      user.stub(:cards => cards)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns the card' do
        do_request
        json = JSON.parse(response.body)
        json['card'].to_json.should == card.as_json.to_json
      end
    end
  end

  describe 'PUT update' do
    def do_request
      put :update, card: attributes_for(:card)
    end

    let(:cards) { double('cards', :find => card) }

    before(:each) do
      user.stub(:cards => cards)
      card.stub(:update_attributes)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to update the record' do
        card.should_receive(:update_attributes).once
        do_request
      end

      context 'update_attributes succeeds' do
        before(:each) do
          card.stub(:update_attributes => true)
        end

        it_behaves_like 'success'
      end

      context 'update_attributes fails' do
        before(:each) do
          card.stub(:update_attributes => false)
          card.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end
end

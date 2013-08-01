require 'spec_helper'

describe Api::V1::EncountersController do
  let(:encounter) { build_stubbed(:encounter) }
  let(:user) { encounter.users.first }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before(:each) do
    controller.stub(:current_ability => ability)
  end

  describe 'GET index' do
    def do_request
      get :index, auth_token: user.auth_token
    end

    it_behaves_like 'action requiring authentication and authorization'
    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'index action', new.encounter
    end
  end

  describe 'GET show' do
    def do_request
      get :show, auth_token: user.auth_token
    end

    let(:encounters) { double('encounters', :find => encounter) }

    before(:each) do
      user.stub(:encounters => encounters)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns the encounter' do
        do_request
        json = JSON.parse(response.body)
        json['encounter'].to_json.should == encounter.as_json.to_json
      end
    end
  end

  describe 'POST create' do
    def do_request
      post :create, encounter: encounter.as_json
    end

    let(:encounters) { double('encounters', :create => encounter) }

    before(:each) do
      user.stub(:encounters => encounters)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to create the record' do
        encounters.should_receive(:create).once
        do_request
      end

      context 'save succeeds' do
        it_behaves_like 'success'

        it 'returns the encounter' do
          do_request
          json = JSON.parse(response.body)
          json['encounter'].to_json.should == encounter.as_json.to_json
        end
      end

      context 'save fails' do
        before(:each) do
          encounter.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end
end

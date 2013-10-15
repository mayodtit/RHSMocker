require 'spec_helper'

describe Api::V1::CreditsController do
  let(:user) { build_stubbed(:member) }
  let(:ability) { Object.new.extend(CanCan::Ability) }
  let(:credit) { build_stubbed(:credit, :user => user) }

  before(:each) do
    controller.stub(:current_ability => ability)
  end

  describe 'GET index' do
    def do_request
      get :index, auth_token: user.auth_token
    end

    before(:each) do
      user.stub(:credits => [credit])
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns an array of credits' do
        do_request
        json = JSON.parse(response.body)
        json['credits'].to_json.should == [credit].as_json.to_json
      end
    end
  end

  describe 'GET show' do
    def do_request
      get :show, auth_token: user.auth_token
    end

    let(:credits) { double('credits', :find => credit) }

    before(:each) do
      user.stub(:credits => credits)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns the credits' do
        do_request
        json = JSON.parse(response.body)
        json['credit'].to_json.should == credit.as_json.to_json
      end
    end
  end

  describe 'POST create' do
    def do_request
      post :create, credit: credit.as_json
    end

    let(:credits) { double('credits', :create => credit) }

    before(:each) do
      user.stub(:credits => credits)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to create the record' do
        credits.should_receive(:create).once
        do_request
      end

      context 'save succeeds' do
        it_behaves_like 'success'

        it 'returns the credit' do
          do_request
          json = JSON.parse(response.body)
          json['credit'].to_json.should == credit.as_json.to_json
        end
      end

      context 'save fails' do
        before(:each) do
          credit.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end
end

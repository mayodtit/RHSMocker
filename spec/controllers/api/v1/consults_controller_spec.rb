require 'spec_helper'

describe Api::V1::ConsultsController do
  let(:consult) { build_stubbed(:consult) }
  let(:user) { consult.users.first }
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
      before(:each) do
        user.stub_chain(:consults, :with_unread_messages_count_for).and_return([consult])
        consult.stub(:unread_messages_count => 1)
      end

      it_behaves_like 'success'

      it "returns an array of Consults" do
        do_request
        json = JSON.parse(response.body, :symbolize_names => true)
        json[:consults].to_json.should == [consult.as_json.merge!(:unread_messages_count => 1)].to_json
      end
    end
  end

  describe 'GET show' do
    def do_request
      get :show, auth_token: user.auth_token
    end

    let(:consults) { double('consults', :find => consult) }

    before(:each) do
      user.stub(:consults => consults)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns the consult' do
        do_request
        json = JSON.parse(response.body)
        json['consult'].to_json.should == consult.as_json.to_json
      end
    end
  end

  describe 'POST create' do
    def do_request
      post :create, consult: consult.as_json
    end

    before(:each) do
      Consult.stub(:create => consult)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to create the record' do
        Consult.should_receive(:create).once
        do_request
      end

      context 'save succeeds' do
        it_behaves_like 'success'

        it 'returns the consult' do
          do_request
          json = JSON.parse(response.body)
          json['consult'].to_json.should == consult.as_json.to_json
        end
      end

      context 'save fails' do
        before(:each) do
          consult.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end
end

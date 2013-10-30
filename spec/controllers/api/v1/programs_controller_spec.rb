require 'spec_helper'

describe Api::V1::ProgramsController do
  let(:user) { build_stubbed(:user) }
  let(:ability) { Object.new.extend(CanCan::Ability) }
  let(:program) { build_stubbed(:program) }

  before(:each) do
    controller.stub(:current_ability => ability)
    Program.stub(:all => [program], :find => program, :create => program)
  end

  describe 'GET index' do
    def do_request
      get :index, auth_token: user.auth_token
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns an array of user conditions' do
        do_request
        json = JSON.parse(response.body)
        json['programs'].to_json.should == [program.as_json].to_json
      end
    end
  end

  describe 'GET show' do
    def do_request
      get :show, auth_token: user.auth_token
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns the user conditions' do
        do_request
        json = JSON.parse(response.body)
        json['program'].to_json.should == program.as_json.to_json
      end
    end
  end

  describe 'POST create' do
    def do_request
      post :create, program: program.as_json
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to create the record' do
        Program.should_receive(:create).once
        do_request
      end

      context 'save succeeds' do
        it_behaves_like 'success'

        it 'returns the user condition' do
          do_request
          json = JSON.parse(response.body)
          json['program'].to_json.should == program.as_json.to_json
        end
      end

      context 'save fails' do
        before(:each) do
          program.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end

  describe 'PUT update' do
    def do_request
      put :update, program: {title: 'new title'}
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to update the record' do
        program.should_receive(:update_attributes).once
        do_request
      end

      context 'update_attributes succeeds' do
        before(:each) do
          program.stub(:update_attributes => true)
        end

        it_behaves_like 'success'
      end

      context 'update_attributes fails' do
        before(:each) do
          program.stub(:update_attributes => false)
          program.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end
end

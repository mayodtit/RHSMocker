require 'spec_helper'

describe Api::V1::ProgramResourcesController do
  let(:user) { build_stubbed(:user) }
  let(:ability) { Object.new.extend(CanCan::Ability) }
  let(:program_resource) { build_stubbed(:program_resource) }
  let(:program) { program_resource.program }

  before do
    controller.stub(current_ability: ability)
    Program.stub(find: program)
    program.stub(program_resources: [program_resource])
  end

  describe 'GET index' do
    def do_request
      get :index, auth_token: user.auth_token
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns an array of program_resources' do
        do_request
        json = JSON.parse(response.body, symbolize_names: true)
        json[:program_resources].to_json.should == [program_resource].as_json.to_json
      end
    end
  end

  describe 'POST create' do
    def do_request
      post :create, program_resource: program_resource.as_json
    end

    let(:program_resources) { double('program_resources', create: program_resource) }

    before do
      program.stub(program_resources: program_resources)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it 'attempts to create the record' do
        program_resources.should_receive(:create).once
        do_request
      end

      context 'save succeeds' do
        it_behaves_like 'success'

        it 'returns the program_resource' do
          do_request
          json = JSON.parse(response.body, symbolize_names: true)
          json[:program_resource].to_json.should == program_resource.as_json.to_json
        end
      end

      context 'save fails' do
        before(:each) do
          program_resource.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end

  describe 'DELETE destroy' do
    def do_request
      delete :destroy
    end

    let(:program_resources) { double('program_resources', find: program_resource) }

    before do
      program.stub(program_resources: program_resources)
      program_resource.stub(:destroy)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it 'attempts to destroy the record' do
        program_resource.should_receive(:destroy).once
        do_request
      end

      context 'destroy succeeds' do
        before do
          program_resource.stub(destroy: true)
        end

        it_behaves_like 'success'
      end

      context 'destroy fails' do
        before do
          program_resource.stub(destroy: false)
          program_resource.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end
end

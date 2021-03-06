require 'spec_helper'

describe Api::V1::ServicesController do
  let(:user) { build_stubbed :pha }
  let(:member) { build_stubbed :member }
  let!(:session) { user.sessions.create }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before(:each) do
    controller.stub(:current_ability => ability)
    Member.stub(:find) { member }
  end

  shared_examples 'service 404' do
    context 'service doesn\'t exist' do
      before do
        Task.stub(:find) { raise(ActiveRecord::RecordNotFound) }
      end

      it_behaves_like '404'
    end
  end

  describe 'POST create' do
    def do_request(params={})
      post :create, params.merge!(auth_token: session.auth_token)
    end

    let(:service_template) { build_stubbed(:service_template) }
    let(:service) { build_stubbed :service, assigned_at: Time.now }
    let(:entry) { build_stubbed :entry }

    before do
      Service.stub(:create) { service }
      service.stub(:entry) { entry }
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to create the record' do
        Service.should_receive(:create).once.and_return(service)
        do_request(service: {service_template_id: service_template.id})
      end

      it 'returns the service' do
        do_request(service: {service_template_id: service_template.id})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:service].to_json).to eq(service.serializer.as_json.to_json)
      end
    end
  end

  describe 'GET index' do
    def do_request(params={})
      get :index, params.merge!(member_id: member.id)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      let(:services) { [build_stubbed(:service), build_stubbed(:service)] }

      before do
        member.stub_chain(:services, :where, :order, :includes).and_return(services)
      end

      it_behaves_like 'success'

      it 'returns services for member filtered by subject_id and state parameter' do
        do_request(subject_id: 1, state: 'unassigned')
        body = JSON.parse(response.body, symbolize_names: true)
        body[:services].to_json.should == services.serializer(shallow: true).as_json.to_json
      end

      it 'doesn\'t allow other query parameters' do
        do_request(subject_id: 1, state: 'unassigned', due_at: 3.days.ago)
        body = JSON.parse(response.body, symbolize_names: true)
        body[:services].to_json.should == services.serializer(shallow: true).as_json.to_json
      end
    end
  end

  describe 'GET show' do
    let(:service) { build_stubbed :service }

    def do_request
      get :show, id: service.id
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it_behaves_like 'service 404'

      context 'service exists' do
        before do
          Service.stub(:find) { service }
        end

        it_behaves_like 'success'

        it 'returns the service' do
          do_request
          body = JSON.parse(response.body, symbolize_names: true)
          body[:service].to_json.should == service.serializer.as_json.to_json
        end
      end
    end
  end

  describe 'PUT update' do
    let(:service) { build_stubbed :service }

    def do_request
      put :update, id: service.id, service: {state_event: 'waiting'}
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it_behaves_like 'service 404'

      context 'service exists' do
        before do
          Service.stub(:find) { service }
        end

        context 'state event is present' do
          it 'sets the actor to the current user' do
            service.should_receive(:update_attributes).with(
              'state_event' => 'waiting',
              'actor_id' => user.id
            )

            service.stub(:owner_id) { user.id }
            service.stub(:assignor_id) { user.id }
            do_request
          end

          context 'service does not have an owner' do
            before do
              service.stub(:owner_id) { nil }
            end

            context 'owner id is not present' do
              def do_request
                put :update, id: service.id, service: {state_event: 'complete'}
              end

              it 'sets owner id to current user' do
                service.should_receive(:update_attributes).with hash_including('owner_id' => user.id)
                do_request
              end
            end

            context 'owner id is present' do
              def do_request
                put :update, id: service.id, service: {state_event: 'complete', owner_id: 2}
              end

              it 'does nothing' do
                service.should_receive(:update_attributes).with hash_including('owner_id' => '2')
                do_request
              end
            end
          end

          context 'service has an owner' do
            before do
              service.stub(:owner_id) { 4 }
            end

            context 'owner id is not present' do
              def do_request
                put :update, id: service.id, service: {state_event: 'start'}
              end

              it 'does nothing' do
                service.should_receive(:update_attributes).with hash_excluding('owner_id')
                do_request
              end
            end

            context 'owner id is present' do
              def do_request
                put :update, id: service.id, service: {state_event: 'start', owner_id: 2}
              end

              it 'does nothing' do
                service.should_receive(:update_attributes).with hash_including('owner_id' => '2')
                do_request
              end
            end
          end
        end

        context 'owner id is present' do
          def do_request
            put :update, id: service.id, service: {owner_id: 2}
          end

          context 'owner id does not match service' do
            before do
              service.stub(:owner_id) { 3 }
            end

            it 'sets assignor_id to current user' do
              service.should_receive(:update_attributes).with hash_including('assignor_id' => user.id)
              do_request
            end
          end

          context 'owner id matches service' do
            before do
              service.stub(:owner_id) { 2 }
            end

            def do_request
              put :update, id: service.id, service: {owner_id: 2}
            end

            it 'does nothing' do
              service.should_receive(:update_attributes).with hash_excluding('assignor_id')
              do_request
            end
          end

          context 'service has no owner' do
            before do
              service.stub(:owner_id) { nil }
            end

            it 'sets assignor_id to current user' do
              service.should_receive(:update_attributes).with hash_including('assignor_id' => user.id)
              do_request
            end
          end
        end

        context 'update is valid' do
          before do
            service.stub(:update_attributes) { true }
          end

          it_behaves_like 'success'
        end

        context 'update is not valid' do
          before do
            service.stub(:update_attributes) { false }
          end

          it_behaves_like 'failure'
        end
      end
    end
  end
end

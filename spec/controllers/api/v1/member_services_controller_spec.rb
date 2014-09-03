require 'spec_helper'

describe Api::V1::MemberServicesController do
  let(:user) { build_stubbed :pha }
  let(:member) { build_stubbed :member }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before do
    controller.stub(:current_ability => ability)
    Member.stub(:find) { member }
  end

  describe 'GET index' do
    def do_request
      get :index, member_id: member.id
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      let(:services) { [build_stubbed(:service), build_stubbed(:service)] }

      it_behaves_like 'success'

      it 'returns services for member filtered by subject_id and state parameter' do
        member.should_receive(:services) do
          o = Object.new
          o.should_receive(:where).with('subject_id' => '1', 'state' => 'unassigned') do
            o_o = Object.new
            o_o.should_receive(:order).with('due_at, created_at ASC') do
              services
            end
            o_o
          end
          o
        end

        get :index, member_id: member.id, subject_id: 1, state: 'unassigned'
        body = JSON.parse(response.body, symbolize_names: true)
        body[:services].to_json.should == services.serializer.as_json.to_json
      end

      it 'doesn\'t allow other query parameters' do
        member.should_receive(:services) do
          o = Object.new
          o.should_receive(:where).with('subject_id' => '1', 'state' => 'unassigned') do
            o_o = Object.new
            o_o.should_receive(:order).with('due_at, created_at ASC') do
              services
            end
            o_o
          end
          o
        end

        get :index, member_id: member.id, subject_id: 1, state: 'unassigned', due_at: 3.days.ago
        body = JSON.parse(response.body, symbolize_names: true)
        body[:services].to_json.should == services.serializer.as_json.to_json
      end
    end
  end
end

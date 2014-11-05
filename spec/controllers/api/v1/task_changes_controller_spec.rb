require 'spec_helper'

describe Api::V1::TaskChangesController do
  let(:user) { build_stubbed :pha }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before(:each) do
    controller.stub(:current_ability => ability)
  end

  describe 'GET index' do
    def do_request
      get :index
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do

      it_behaves_like 'success'

      let(:task_changes) {[build_stubbed(:task_change), build_stubbed(:task_change)]}
      it 'provides a list of TaskChanges for a certain user' do
        TaskChange.should_receive(:where).with(actor_id: user.id) do
          o = Object.new
          o.should_receive(:order).with('created_at DESC') do
            o_o = Object.new
            o_o.should_receive(:includes).with(:actor, task: :member) { task_changes }
            o_o
          end
          o
        end

        get :index
        body = JSON.parse(response.body, symbolize_names: true)
        body[:task_changes].to_json.should == task_changes.serializer.as_json.to_json
      end
    end
  end
end
require 'spec_helper'

describe Api::V1::MemberTasksController do
  let(:user) { build_stubbed :pha }
  let(:member) { build_stubbed :member }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before do
    controller.stub(:current_ability => ability)
    Member.stub(:find) { member }
  end

  describe 'GET index' do
    def do_request
      get :index, member_id: member.id, auth_token: user.auth_token
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      let(:tasks) { [build_stubbed(:task), build_stubbed(:task)] }

      it_behaves_like 'success'

      it 'returns tasks for member filtered by subject_id and state parameter' do
        member.should_receive(:tasks) do
          o = Object.new
          o.should_receive(:where).with('subject_id' => '1', 'state' => 'unassigned') { tasks }
          o
        end

        get :index, member_id: member.id, auth_token: user.auth_token, subject_id: 1, state: 'unassigned'
        body = JSON.parse(response.body, symbolize_names: true)
        body[:tasks].to_json.should == tasks.serializer.as_json.to_json
      end

      it 'doesn\'t allow other query parameters' do
        member.should_receive(:tasks) do
          o = Object.new
          o.should_receive(:where).with('subject_id' => '1', 'state' => 'unassigned') { tasks }
          o
        end

        get :index, member_id: member.id, auth_token: user.auth_token, subject_id: 1, state: 'unassigned', due_at: 3.days.ago
        body = JSON.parse(response.body, symbolize_names: true)
        body[:tasks].to_json.should == tasks.serializer.as_json.to_json
      end
    end
  end

  describe 'POST create' do
    let(:task) { build_stubbed :task }

    before do
      member.stub(:tasks) do
        o = Object.new
        o.stub(:create) { task }
        o
      end
    end

    def do_request(state_event = nil)
      task_attributes = {title: 'Title'}

      if state_event
        task_attributes[:state_event] = state_event
      end

      post :create, auth_token: user.auth_token, member_id: member.id, task: task_attributes
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'sets the creator to the current user' do
        member.should_receive(:tasks) do
          o = Object.new
          o.should_receive(:create).with('creator' => user, 'title' => 'Title') { task }
          o
        end

        do_request
      end

      it 'serializes the task' do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        body[:task].to_json.should == task.serializer.as_json.to_json
      end

      context 'state event is present' do
        context 'state event is assign' do
          it 'assigns the actor to the current user' do
            member.should_receive(:tasks) do
              o = Object.new
              o.should_receive(:create).with(
                'creator' => user,
                'title' => 'Title',
                'state_event' => 'assign',
                'assignor' => user) { task }
              o
            end

            do_request 'assign'
          end
        end

        context 'state event is not assign' do
          it 'assigns the actor to the current user' do
            member.should_receive(:tasks) do
              o = Object.new
              o.should_receive(:create).with(
                'creator' => user,
                'title' => 'Title',
                'state_event' => 'complete') { task }
              o
            end

            do_request 'complete'
          end
        end
      end
    end
  end
end

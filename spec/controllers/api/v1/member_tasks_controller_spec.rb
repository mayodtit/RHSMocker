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
      get :index, member_id: member.id
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      let(:tasks) { [build_stubbed(:task), build_stubbed(:task)] }

      it_behaves_like 'success'

      it 'returns tasks for member filtered by subject_id and state parameter' do
        member.should_receive(:tasks) do
          o = Object.new
          o.should_receive(:where).with('subject_id' => '1', 'state' => 'unassigned') do
            o_o = Object.new
            o_o.should_receive(:order).with("field(state, 'unclaimed', 'claimed', 'blocked_internal', 'blocked_external', 'completed', 'abandoned'), due_at DESC, created_at DESC") do
              o_o_o = Object.new
              o_o_o.should_receive(:includes).with(:service_type, :owner) { tasks }
              o_o_o
            end
            o_o
          end
          o
        end

        get :index, member_id: member.id, subject_id: 1, state: 'unassigned'
        body = JSON.parse(response.body, symbolize_names: true)
        body[:tasks].to_json.should == tasks.serializer(for_subject: true).as_json.to_json
      end

      it 'doesn\'t allow other query parameters' do
        member.should_receive(:tasks) do
          o = Object.new
          o.should_receive(:where).with('subject_id' => '1', 'state' => 'unassigned') do
            o_o = Object.new
            o_o.should_receive(:order).with("field(state, 'unclaimed', 'claimed', 'blocked_internal', 'blocked_external', 'completed', 'abandoned'), due_at DESC, created_at DESC") do
              o_o_o = Object.new
              o_o_o.should_receive(:includes).with(:service_type, :owner) { tasks }
              o_o_o
            end
            o_o
          end
          o
        end

        get :index, member_id: member.id, subject_id: 1, state: 'unassigned', due_at: 3.days.ago
        body = JSON.parse(response.body, symbolize_names: true)
        body[:tasks].to_json.should == tasks.serializer(for_subject: true).as_json.to_json
      end

      context 'when the member is the subject' do
        it 'return ParsedNurselineRecordTasks' do
          member.should_receive(:tasks) do
            o = Object.new
            o.should_receive(:where).with(subject_id: [member.id.to_s, nil]) do
              o_o = Object.new
              o_o.should_receive(:where).with('state' => 'unassigned') do
                o_o_o = Object.new
                o_o_o.should_receive(:order).with("field(state, 'unclaimed', 'claimed', 'blocked_internal', 'blocked_external', 'completed', 'abandoned'), due_at DESC, created_at DESC") do
                  o_o_o_o = Object.new
                  o_o_o_o.should_receive(:includes).with(:service_type, :owner) { tasks }
                  o_o_o_o
                end
                o_o_o
              end
              o_o
            end
            o
          end

          get :index, member_id: member.id, subject_id: member.id, state: 'unassigned', due_at: 3.days.ago
          body = JSON.parse(response.body, symbolize_names: true)
          body[:tasks].to_json.should == tasks.serializer(for_subject: true).as_json.to_json
        end
      end
    end
  end

  describe 'POST create' do
    let(:task) { build_stubbed :task }
    let(:entry) { build_stubbed :entry}
    before do
      MemberTask.stub(:create) { task }
      task.stub(:reload)
      task.stub(:entry) { entry }
    end

    def do_request
      task_attributes = {title: 'Title'}
      post :create, member_id: member.id, task: task_attributes
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'sets the creator to the current user' do
        MemberTask.should_receive(:create).with('creator' => user, 'title' => 'Title', 'member_id' => member.id, 'actor_id' => user.id) { task }

        do_request
      end

      it 'serializes the task' do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        body[:task].to_json.should == task.serializer.as_json.to_json
      end

      context 'owner id is present' do
        it 'sets assignor_id to current user' do
          MemberTask.should_receive(:create).with(hash_including('assignor_id' => user.id)) { task }

          post :create, member_id: member.id, task: {owner_id: 2}
        end
      end

      context 'owner id is not present' do
        it 'sets assignor_id to current user' do
          MemberTask.should_receive(:create).with(hash_excluding('assignor_id')) { task }
          post :create, member_id: member.id, task: {title: 'Title'}
        end
      end
    end
  end
end

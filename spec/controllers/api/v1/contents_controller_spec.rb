require 'spec_helper'

describe Api::V1::ContentsController do
  let(:content) { build_stubbed(:content) }
  let(:user) { build_stubbed(:member) }
  let(:ability) { Object.new.extend(CanCan::Ability) }
  let(:content_keys) { content.active_model_serializer_instance.as_json.keys.map(&:to_sym) }

  before do
    controller.stub(:current_ability => ability)
  end

  describe 'GET index' do
    def do_request
      get :index, auth_token: user.auth_token
    end

    before(:each) do
      Content.stub(:order => [content])
    end

    it_behaves_like 'action requiring authentication'

    context 'authenticated', :user => :authenticate! do
      it_behaves_like 'success'

      it 'returns an array of contents' do
        do_request
        json = JSON.parse(response.body, :symbolize_names => true)
        json[:contents].first.keys.should =~ content_keys
      end

      it 'logs the content search to analytics' do
        Analytics.should_receive(:log_content_search).once
        do_request
      end
    end
  end

  describe 'POST like' do
    def do_request
      post :like, auth_token: user.auth_token, content_id: content.id
    end

    it_behaves_like 'action requiring authentication'

    context 'authenticated', :user => :authenticate! do
      it 'should call User#like_content' do
        user.should_receive(:like_content).with(content.id.to_s)
        do_request
      end
    end
  end

  describe 'POST dislike' do
    def do_request
      post :dislike, auth_token: user.auth_token, content_id: content.id
    end

    it_behaves_like 'action requiring authentication'

    context 'authenticated', :user => :authenticate! do
      it 'should call User#dislike_content' do
        user.should_receive(:dislike_content).with(content.id.to_s)
        do_request
      end
    end
  end

  describe 'POST remove_like' do
    def do_request
      post :remove_like, auth_token: user.auth_token, content_id: content.id
    end

    it_behaves_like 'action requiring authentication'

    context 'authenticated', :user => :authenticate! do
      it 'should call User#remove_content_like' do
        user.should_receive(:remove_content_like).with(content.id.to_s)
        do_request
      end
    end
  end
end

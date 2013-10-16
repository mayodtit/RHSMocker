require 'spec_helper'

describe Api::V1::ContentsController do
  let(:content) { create(:content) }
  let(:user)    { create(:member) }

  before(:each) do
    user.login
  end

  describe 'POST like' do
    it 'should call User#like_content' do
      User.any_instance.should_receive(:like_content).with(content.id.to_s)
      post :like, auth_token: user.auth_token, content_id: content.id
    end
  end

  describe 'POST dislike' do
    it 'should call User#dislike_content' do
      User.any_instance.should_receive(:dislike_content).with(content.id.to_s)
      post :dislike, auth_token: user.auth_token, content_id: content.id
    end

  end

  describe 'POST remove_like' do
    it 'should call User#remove_content_like' do
      User.any_instance.should_receive(:remove_content_like).with(content.id.to_s)
      post :remove_like, auth_token: user.auth_token, content_id: content.id
    end
  end
end

require 'spec_helper'

describe PubSub do
  describe '#publish_without_delay' do
    it 'does nothing unless metadata says so' do
      Metadata.stub(:find_by_mkey).with('use_pub_sub') do
        o = Object
        o.stub(:try).with(:mvalue) { nil }
        o
      end

      Net::HTTP.should_not_receive(:post_form)
      PubSub.publish_without_delay('/messages', {id: 1})
    end

    context 'metadata activates' do
      let(:uri) { 'http://www.example.com' }

      before do
        Metadata.stub(:find_by_mkey).with('use_pub_sub') do
          o = Object
          o.stub(:try).with(:mvalue) { 'true' }
          o
        end
        Net::HTTP.stub(:post_form)
      end

      it 'sends to PUB_SUB_HOST' do
        URI.stub(:parse).with(PUB_SUB_HOST) { uri }
        Net::HTTP.should_receive(:post_form) do |uri, body|
          uri.should == 'http://www.example.com'
        end
        PubSub.publish_without_delay('/bodys', {id: 1})
      end

      it 'sets the secret' do
        Net::HTTP.should_receive(:post_form) do |uri, body|
          message = JSON.parse(body[:message])
          message['ext']['secret'].should == PUB_SUB_SECRET
        end
        PubSub.publish_without_delay('/bodys', {id: 1})
      end

      it 'sets the channel according to the env' do
        Rails.stub(:env) { 'production' }
        Net::HTTP.should_receive(:post_form) do |uri, body|
          message = JSON.parse(body[:message])
          message['channel'].should == '/production/messages'
        end
        PubSub.publish_without_delay('/messages', {id: 1})
      end

      it 'sets data' do
        Rails.stub(:env) { 'production' }
        Net::HTTP.should_receive(:post_form) do |uri, body|
          message = JSON.parse(body[:message])
          message['data']['id'].should == 1
        end
        PubSub.publish_without_delay('/messages', {id: 1})
      end
    end
  end
end

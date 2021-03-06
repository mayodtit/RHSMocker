require 'spec_helper'

describe Api::V1::ContentsController do
  let(:content) { build_stubbed(:content, :published) }
  let(:user) { build_stubbed(:member) }
  let(:ability) { Object.new.extend(CanCan::Ability) }
  let(:content_keys) { content.serializer.as_json.keys.map(&:to_sym) }

  before do
    controller.stub(:current_ability => ability)
  end

  describe 'GET index' do
    def do_request(params={})
      get :index, params
    end

    it_behaves_like 'action requiring authentication'

    context 'authenticated', :user => :authenticate! do
      context 'sql query' do
        let(:results) { [content] }

        before(:each) do
          Content.stub_chain(:order, :published, :page, :per).and_return(results)
          results.stub(total_count: 1)
        end

        it_behaves_like 'success'

        it 'returns an array of contents' do
          do_request
          json = JSON.parse(response.body, :symbolize_names => true)
          json[:contents].first.keys.should =~ content_keys
        end

        context 'with search term' do
          it 'logs the content search to analytics' do
            Analytics.should_not_receive(:log_content_search)
            do_request
          end
        end

        context 'with nil search term' do
          it 'logs the content search to analytics' do
            Analytics.should_receive(:log_content_search).once
            do_request(q: 'diabetes')
          end
        end
      end

      context 'solr query' do
        let(:search) { double(results: [content], total: 1) }

        before do
          Content.should_receive(:search).once
          Content.stub(search: search)
        end

        it 'returns an array of contents' do
          do_request(q: 'diabetes')
          json = JSON.parse(response.body, :symbolize_names => true)
          json[:contents].first.keys.should =~ content_keys
        end
      end
    end
  end

  describe 'GET show' do
    def do_request
      get :show
    end

    let(:content_keys) { content.serializer(body: true).as_json.keys.map(&:to_sym) }

    before do
      Content.stub_chain(:published, :find).and_return(content)
    end

    it_behaves_like 'action requiring authentication'

    context 'authenticated', :user => :authenticate! do
      it_behaves_like 'success'

      it 'returns the content' do
        do_request
        json = JSON.parse(response.body, :symbolize_names => true)
        json[:content].keys.should =~ content_keys
      end
    end
  end

  describe 'POST like' do
    def do_request
      post :like, content_id: content.id
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
      post :dislike, content_id: content.id
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
      post :remove_like, content_id: content.id
    end

    it_behaves_like 'action requiring authentication'

    context 'authenticated', :user => :authenticate! do
      it 'should call User#remove_content_like' do
        user.should_receive(:remove_content_like).with(content.id.to_s)
        do_request
      end
    end
  end

  describe 'GET tos' do
    def do_request
      get :tos
    end

    let!(:content) { build_stubbed(:mayo_content, :tos) }

    before do
      MayoContent.stub(terms_of_service: content)
    end

    it_behaves_like 'action requiring authentication'

    context 'authenticated', :user => :authenticate! do
      it_behaves_like 'success'

      it 'returns the content' do
        do_request
        json = JSON.parse(response.body, :symbolize_names => true)
        expect(json[:content].to_json).to eq(content.serializer.as_json.to_json)
      end
    end
  end
end

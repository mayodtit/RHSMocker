require 'spec_helper'

describe Api::V1::ContentReferencesController do
  let(:user) { build_stubbed(:admin) }
  let(:content) { build_stubbed(:content) }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before do
    controller.stub(current_ability: ability)
    Content.stub(:find => content)
  end

  context 'existing record' do
    let!(:content_reference) { build_stubbed(:content_reference, referrer: content) }

    before do
      content.stub(:content_references => [content_reference])
    end

    describe 'GET inbox' do
      def do_request
        get :index
      end

      it_behaves_like 'action requiring authentication and authorization'

      context 'authenticated and authorized', user: :authenticate_and_authorize! do
        it_behaves_like 'success'

        it 'returns an array of content_references' do
          do_request
          json = JSON.parse(response.body)
          json['content_references'].to_json.should == [content_reference].serializer.as_json.to_json
        end
      end
    end
  end

  describe 'POST create' do
    def do_request
      post :create, content_reference: {referee_id: 1}
    end

    let(:content_reference) { build_stubbed(:content_reference, referrer: content) }
    let(:content_references) { double('content_reference', create: content_reference) }

    before do
      content.stub(:content_references => content_references)
      content_reference.stub(:reload)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it 'attempts to create the record' do
        content_references.should_receive(:create).once
        do_request
      end

      context 'save succeeds' do
        it_behaves_like 'success'

        it 'returns the content_reference' do
          do_request
          json = JSON.parse(response.body)
          json['content_reference'].to_json.should == content_reference.serializer.as_json.to_json
        end
      end

      context 'save fails' do
        before(:each) do
          content_reference.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end
end

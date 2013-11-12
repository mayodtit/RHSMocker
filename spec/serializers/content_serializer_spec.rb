require 'spec_helper'

describe ContentSerializer do
  let(:resource) { build_stubbed(:content) }
  it_behaves_like 'preview-renderable resource'
  it_behaves_like 'body-renderable resource'
  it_behaves_like 'resource that can be a card'

  describe 'attributes' do
    def serializer(options={})
      described_class.new(resource, options)
    end

    it 'renders the raw_body when set' do
      serializer(raw_body: true).as_json[:raw_body].should == resource.body
    end

    it 'renders the raw_preview when set' do
      serializer(raw_preview: true).as_json[:raw_preview].should_not be_nil
    end
  end
end

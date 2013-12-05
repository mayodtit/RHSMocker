require 'spec_helper'

describe ViewSerializer do
  def view_serializer(options={})
    described_class.new(build_stubbed(:content), options)
  end

  let(:with_preview) { view_serializer(preview: true) }
  let(:with_body) { view_serializer(body: true) }
  let(:raw_preview) { view_serializer(raw_preview: true) }
  let(:raw_body) { view_serializer(raw_body: true) }

  describe '#attributes' do
    before do
      with_preview.stub(preview: double('preview'))
      with_body.stub(body: double('body'))
      raw_preview.stub(raw_preview: double('raw_preview'))
      raw_body.stub(raw_body: double('raw_body'))
    end

    it 'renders preview when set' do
      with_preview.as_json[:preview].should_not be_nil
    end

    it 'renders body when set' do
      with_body.as_json[:body].should_not be_nil
    end

    it 'renders raw_preview when set' do
      raw_preview.as_json[:raw_preview].should_not be_nil
    end

    it 'renders raw_body when set' do
      raw_body.as_json[:raw_body].should_not be_nil
    end
  end

  describe '#partial_name' do
    it 'returns the underscored class name of the resource' do
      view_serializer.partial_name.should == 'content'
    end
  end
end

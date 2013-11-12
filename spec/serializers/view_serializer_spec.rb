require 'spec_helper'

describe ViewSerializer do
  def view_serializer(options={})
    described_class.new(build_stubbed(:content), options)
  end

  let(:card_actions) { view_serializer(card_actions: true) }
  let(:full_actions) { view_serializer(full_actions: true) }

  describe 'options' do
    let(:without) { view_serializer }
    let(:with_preview) { view_serializer(preview: true) }
    let(:with_body) { view_serializer(body: true) }
    let(:with_both) { view_serializer(preview: true, body: true) }

    it 'defaults to without' do
      view_serializer.send(:render_preview?).should be_false
      view_serializer.send(:render_body?).should be_false
    end

    it 'sets preview to true when set' do
      with_preview.send(:render_preview?).should be_true
      with_preview.send(:render_body?).should be_false
    end

    it 'sets body to true when set' do
      with_body.send(:render_preview?).should be_false
      with_body.send(:render_body?).should be_true
    end

    it 'sets both to true when set' do
      with_both.send(:render_preview?).should be_true
      with_both.send(:render_body?).should be_true
    end

    it 'sets card_actions to true when set' do
      card_actions.send(:card_actions?).should be_true
    end

    it 'sets full_actions to true when set' do
      full_actions.send(:full_actions?).should be_true
    end
  end

  describe '#attributes' do
    before do
      card_actions.stub(card_actions: double('card_actions'))
      full_actions.stub(full_actions: double('full_actions'))
    end

    it 'sets actions when card_actions is set' do
      card_actions.as_json[:actions].should == card_actions.card_actions
    end

    it 'sets actions when full_actions is set' do
      full_actions.as_json[:actions].should == full_actions.full_actions
    end
  end

  describe '#partial_name' do
    it 'returns the downcased class name of the resource' do
      view_serializer.partial_name.should == 'content'
    end
  end
end

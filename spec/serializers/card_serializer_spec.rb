require 'spec_helper'

shared_examples 'renders successfully' do
  it 'renders' do
    card_serializer.as_json.should_not be_nil
  end

  it 'renders with preview' do
    json = card_serializer(preview: true).as_json
    json[:preview].should_not be_nil
  end

  it 'renders with body' do
    json = card_serializer(body: true).as_json
    json[:body].should_not be_nil
  end
end

describe CardSerializer do
  def card_serializer(options={})
    described_class.new(resource, options)
  end

  context 'with a content card' do
    let(:resource) { build_stubbed(:card, :content_card) }
    it_behaves_like 'renders successfully'
  end

  context 'with a question card' do
    let(:resource) { build_stubbed(:card, :question_card) }
    it_behaves_like 'renders successfully'
  end

  context 'with a consult card' do
    let(:resource) { build_stubbed(:card, :consult_card) }
    it_behaves_like 'renders successfully'
  end

  context 'with a consult card' do
    let(:resource) { build_stubbed(:card, :consult_card_with_messages) }
    it_behaves_like 'renders successfully'
  end
end

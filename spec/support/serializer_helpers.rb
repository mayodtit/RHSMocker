shared_examples 'preview-renderable resource' do
  it 'renders the preview' do
    serializer = described_class.new(resource, preview: true)
    serializer.as_json.keys.should include(:preview)
  end
end

shared_examples 'body-renderable resource' do
  it 'renders the body' do
    serializer = described_class.new(resource, body: true)
    serializer.as_json.keys.should include(:body)
  end
end

shared_examples 'resource that can be a card' do
  it 'responds to required messages' do
    serializer = described_class.new(resource, preview: true)
    [:title, :content_type, :content_type_display, :share_url,
     :raw_body, :raw_preview, :partial_name, :card_actions].each do |key|
      serializer.should respond_to(key)
    end
  end
end

require 'spec_helper'

describe CustomCardSerializer do
  let(:resource) { build_stubbed(:custom_card) }
  it_behaves_like 'preview-renderable resource'
  it_behaves_like 'body-renderable resource'
  it_behaves_like 'resource that can be a card'
end

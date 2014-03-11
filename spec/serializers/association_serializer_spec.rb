require 'spec_helper'

describe AssociationSerializer do
  let(:resource) { build_stubbed(:association, :pending) }
  it_behaves_like 'preview-renderable resource'
  it_behaves_like 'body-renderable resource'
  it_behaves_like 'resource that can be a card'
end

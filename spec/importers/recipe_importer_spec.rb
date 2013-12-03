require 'spec_helper'

describe RecipeImporter do
  it 'works' do
    expect{ described_class.new(Nokogiri::XML(open(Rails.root + 'db/mayo_content/RE00005.xml'))).import }.to change{ Content.count }.by(1)
  end
end

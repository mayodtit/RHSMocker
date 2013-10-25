require 'spec_helper'

describe ContentImporter do
  it 'works' do
    expect{ ContentImporter.new(Nokogiri::XML(open(Rails.root + 'db/mayo_content/DS00585.xml'))).import }.to change{ Content.count }.by(1)
  end
end

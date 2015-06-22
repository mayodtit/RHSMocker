require 'spec_helper'

describe DataField do
  it_has_a 'valid factory'
  it_validates 'presence of', :service
  it_validates 'presence of', :data_field_template
  it_validates 'uniqueness of', :data_field_template_id, :service_id

  describe '#completed' do
    let(:data_field) { build_stubbed(:data_field) }

    it "returns false if there isn't data" do
      expect(data_field).to_not be_completed
    end

    it "returns true if there is data" do
      data_field.data = "hello world"
      expect(data_field).to be_completed
    end
  end
end

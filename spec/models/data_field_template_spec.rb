require 'spec_helper'

describe DataFieldTemplate do
  it_has_a 'valid factory'
  it_validates 'presence of', :service_template
  it_validates 'presence of', :name
  it_validates 'uniqueness of', :name, :service_template_id
  it_validates 'presence of', :type
  it_validates 'inclusion of', :type
  it_validates 'inclusion of', :required_for_service_start

  describe '#create_deep_copy!' do
    let!(:origin_data_field_template) { create(:data_field_template) }
    let!(:new_service_template) { create(:service_template) }
    let(:origin_data_field_template_attributes) { origin_data_field_template.attributes.slice(*%w(name type required_for_service_start)) }

    it 'creates a copy of key attributes from the origin for the new service template' do
      new_data_field_template = origin_data_field_template.create_deep_copy!(new_service_template)
      expect(new_data_field_template).to be_valid
      expect(new_data_field_template).to be_persisted
      expect(new_data_field_template.service_template).to eq(new_service_template)
      new_data_field_template_attributes = new_data_field_template.attributes.slice(*%w(name type required_for_service_start))
      expect(new_data_field_template_attributes).to eq(origin_data_field_template_attributes)
    end
  end
end

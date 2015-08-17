require 'spec_helper'

describe TaskTemplate do
  it_has_a 'valid factory'
  it_has_a 'valid factory', :with_service_template

  describe 'validations' do
    before do
      described_class.any_instance.stub(:copy_title_to_name)
    end

    it_validates 'presence of', :name
    it_validates 'presence of', :title
    it_validates 'foreign key of', :service_template
    it_validates 'foreign key of', :modal_template
  end

  describe '#create_deep_copy!' do
    let!(:origin_task_step_data_field_template) { create(:task_step_data_field_template) }
    let!(:origin_data_field_template) { origin_task_step_data_field_template.data_field_template }
    let!(:origin_task_step_template) { origin_task_step_data_field_template.task_step_template }
    let!(:origin_task_template) { origin_task_step_template.task_template }
    let!(:origin_service_template) { origin_task_template.service_template }
    let(:origin_task_template_attributes) { origin_task_template.attributes.slice(*%w(name title description time_estimate priority service_ordinal queue task_category_id expertise_id)) }

    let!(:new_service_template) { create(:service_template) }
    let!(:new_data_field_template) do
      create(:data_field_template, service_template: new_service_template,
                                   name: origin_data_field_template.name,
                                   type: origin_data_field_template.type,
                                   required_for_service_start: origin_data_field_template.required_for_service_start)
    end

    it 'creates a deep copy including nested templates' do
      new_task_template = origin_task_template.create_deep_copy!(new_service_template)
      expect(new_task_template).to be_valid
      expect(new_task_template).to be_persisted
      expect(new_task_template.service_template).to eq(new_service_template)
      expect(new_task_template.data_field_templates).to include(new_data_field_template)
      expect(new_task_template.task_step_templates.count).to eq(1)
      expect(new_task_template.task_step_templates.first.data_field_templates).to include(new_data_field_template)
      new_task_template_attributes = new_task_template.attributes.slice(*%w(name title description time_estimate priority service_ordinal queue task_category_id expertise_id))
      expect(new_task_template_attributes).to eq(origin_task_template_attributes)
    end
  end
end

require 'spec_helper'

describe ServiceTemplate do
  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'presence of', :name
    it_validates 'presence of', :title
    it_validates 'presence of', :service_type
    it_validates 'inclusion of', :user_facing
    it_validates 'presence of', :version
    it_validates 'presence of', :state
    it_validates 'uniqueness of', :state, :unique_id
    it_validates 'uniqueness of', :version, :unique_id
  end

  describe '#calculated_due_at' do
    before do
      Timecop.freeze(Time.parse('2015-06-02 09:00:00 -0700'))
    end

    after do
      Timecop.return
    end

    let(:service_template) { described_class.new(time_estimate: 1) }

    it 'calcuates due_at in relative business minutes' do
      expect(service_template.calculated_due_at).to eq(Time.parse('2015-06-02 09:01:00 -0700'))
    end
  end

  describe '#create_deep_copy!' do
    let!(:origin_service_template) { create(:service_template, :published) }
    let!(:origin_task_template) { create(:task_template, service_template: origin_service_template) }
    let!(:origin_task_step_template) { create(:task_step_template, task_template: origin_task_template) }
    let!(:origin_data_field_template) { create(:data_field_template, service_template: origin_service_template) }
    let(:origin_service_template_attributes) { origin_service_template.attributes.slice(*%w(name title description service_type_id time_estimate timed_service user_facing service_update service_request unique_id)) }

    before do
      origin_task_step_template.add_data_field_template!(origin_data_field_template)
    end

    it 'creates a deep copy including nested templates' do
      new_service_template = origin_service_template.create_deep_copy!
      expect(new_service_template).to be_valid
      expect(new_service_template).to be_persisted
      expect(new_service_template.data_field_templates.count).to eq(1)
      new_data_field_template = new_service_template.data_field_templates.first
      expect(new_service_template.task_templates.count).to eq(1)
      new_task_template = new_service_template.task_templates.first
      expect(new_task_template.task_step_templates.count).to eq(1)
      new_task_step_template = new_task_template.task_step_templates.first
      expect(new_task_step_template.data_field_templates).to include(new_data_field_template)
      new_service_template_attributes = new_service_template.attributes.slice(*%w(name title description service_type_id time_estimate timed_service user_facing service_update service_request unique_id))
      expect(new_service_template_attributes).to eq(origin_service_template_attributes)
    end
  end

  describe 'create_initial_task_template_set' do
    let(:task_template_set) { build_stubbed(:task_template_set) }

    it 'creates an initial task with the current ServiceTemplate' do
      task_template_set.should_receive(:create_initial_task_template_set) { task_template_set }

      task_template_set.create_initial_task_template_set.should == task_template_set
    end
  end
end

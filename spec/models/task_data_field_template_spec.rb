require 'spec_helper'

describe TaskDataFieldTemplate do
  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'presence of', :task_template
    it_validates 'presence of', :data_field_template
    it_validates 'uniqueness of', :data_field_template_id, :task_template_id

    describe 'ordinal validations' do
      before do
        described_class.any_instance.stub(:set_defaults)
      end

      it_validates 'presence of', :ordinal
      it_validates 'uniqueness of', :ordinal, :task_template_id, :type
      it_validates 'numericality of', :ordinal
      it_validates 'integer numericality of', :ordinal
    end

    describe '#associations_have_same_service_template' do
      let!(:service_template_1) { create(:service_template) }
      let!(:service_template_2) { create(:service_template) }
      let!(:task_template) { create(:task_template, service_template: service_template_1) }
      let!(:data_field_template) { create(:data_field_template, service_template: service_template_2) }

      it 'adds an error if the service template of associations is different' do
        t = described_class.new(task_template: task_template, data_field_template: data_field_template)
        expect(t).to_not be_valid
        expect(t.errors[:base]).to include('associations must have same service template')
      end
    end
  end
end

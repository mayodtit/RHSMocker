require 'spec_helper'
require 'timecop'

describe CommunicationWorkflowTemplate do
  it_has_a 'valid factory'

  describe 'validations' do
    before do
      described_class.any_instance.stub(:set_defaults)
    end

    it_validates 'presence of', :communication_workflow
    it_validates 'presence of', :relative_days
    it_validates 'presence of', :relative_hours
    it_validates 'numericality of', :relative_days
    it_validates 'numericality of', :relative_hours
  end

  describe '#relative_publish_at' do
    new_time = Time.local(2015, 1, 10, 10, 0, 0)
    Timecop.freeze(new_time)

    context 'when relative days is equal to 0 day' do
      let!(:communication_workflow_template) { create :communication_workflow_template }

      it 'sending at 10am if it is between 8-9am' do
        expect( communication_workflow_template.relative_publish_at()).to eq(Time.local(2015, 1, 11, 10, 0, 0))
      end

      it 'sending one hour later if it is after 9am' do

      end

      it 'sending at 9am if it is before 8am' do

      end

      it 'sending at 9am one day after if it is during off hours' do

      end
    end

    context 'when relative days is greater than 0 day' do
      let!(communication_workflow_template) { create :communication_workflow_template,
                                                     relative_days: 1,
                                                     relative_hours: 2}

      it 'sending the relatives days later at 9am' do
        expect( communication_workflow_template.relative_publish_at()).to eq(Time.local(2015, 1, 11, 10, 0, 0))
      end
    end

    context 'when relative days is smaller than 0 day' do

    end
  end
end

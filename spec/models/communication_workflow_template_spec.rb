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
    context 'when relative days is equal to 0 day and relative hour is greater than zero' do
      let!(:communication_workflow_template) { create :communication_workflow_template,
                                                     relative_days: 0,
                                                     relative_hours: 1}
      let(:reference_time) { Time.local(2015, 1, 12, 9, 0, 0 ).utc }

      context 'Time now + relative hour is between 8am -9am' do
        before do
          new_time = Time.local(2015, 1, 13, 15, 30, 0)
          Timecop.freeze(new_time)
        end

        after do
          Timecop.return
        end

        it 'should publish at 10am' do
          expect( communication_workflow_template.send( :relative_publish_at, reference_time).pacific ).to eq( Time.local(2015, 1, 13, 18, 0, 0).pacific)
        end
      end

      context 'Time now + relative hour is after 9am, but before business close' do
        before do
          new_time = Time.local(2015, 1, 13, 19, 30, 0).utc
          Timecop.freeze(new_time)
        end

        after do
          Timecop.return
        end

        it 'should publish one hour later if it is after 9am' do
          expect( communication_workflow_template.send(:relative_publish_at, reference_time).pacific ).to eq( Time.local(2015, 1, 13, 21, 30, 0).pacific)
        end
      end

      context 'Time now + relative hour is before 8am' do
        before do
          new_time = Time.local(2015, 1, 13, 14, 30, 0)
          Timecop.freeze(new_time)
        end

        after do
          Timecop.return
        end

        it 'publish at 9am if it is before 8am' do
          expect( communication_workflow_template.send(:relative_publish_at, reference_time).pacific ).to eq( Time.local(2015, 1, 13, 17, 0, 0).pacific)
        end
      end

      context 'Time now + relative hour is not in business hour' do
        before do
          new_time = Time.local(2015, 1, 14, 5, 30, 0).pacific
          Timecop.freeze(new_time)
        end

        after do
          Timecop.return
        end

        it 'sending at 9am one day after if it is during off hours' do
          expect( communication_workflow_template.send(:relative_publish_at, reference_time).pacific ).to eq( Time.local(2015, 1, 13, 17, 0, 0).pacific)
        end
      end
    end

    context 'when relative days is equal to zero and relative hour is no greater than zero' do
      let!(:communication_workflow_template) { create :communication_workflow_template,
                                                      relative_days: 0,
                                                      relative_hours: -1}
      let(:reference_time) { Time.local(2015, 1, 12, 9, 0, 0 ) }

      before do
        new_time = Time.local(2015, 1, 13, 17, 30, 0)
        Timecop.freeze(new_time)
      end

      after do
        Timecop.return
      end

      it 'should publish at one hour before time now' do
        expect( communication_workflow_template.send(:relative_publish_at, reference_time).pacific ).to eq( Time.local(2015, 1, 13, 16, 30, 0).pacific)
      end
    end


    context 'when relative days is greater than 0 day' do
      let!(:communication_workflow_template) { create :communication_workflow_template,
                                                     relative_days: 1,
                                                     relative_hours: 2}
      let(:reference_time) { Time.local(2015, 1, 12, 9, 0, 0 ) }

      before do
        new_time = Time.local(2015, 1, 13, 17, 30, 0)
        Timecop.freeze(new_time)
      end

      after do
        Timecop.return
      end

      it 'sending the relatives days later at 9am' do
        expect( communication_workflow_template.send(:relative_publish_at, reference_time).pacific ).to eq(Time.local(2015, 1, 13, 17, 0, 0).pacific)
      end
    end

    context 'when relative days is smaller than 0 day' do
      let!(:communication_workflow_template) { create :communication_workflow_template,
                                                     relative_days: -1,
                                                     relative_hours: 2}
      let(:reference_time) { Time.local(2015, 1, 12, 9, 0, 0 ) }

      before do
        new_time = Time.local(2015, 1, 13, 17, 30, 0)
        Timecop.freeze(new_time)
      end

      after do
        Timecop.return
      end

      it 'sending the relatives days before at 9am' do
        expect( communication_workflow_template.send(:relative_publish_at, reference_time).pacific ).to eq(Time.local(2015, 1, 9, 17, 0, 0).pacific)
      end
    end
  end
end

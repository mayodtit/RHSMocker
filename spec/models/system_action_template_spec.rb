require 'spec_helper'

describe SystemActionTemplate do
  it_has_a 'valid factory'
  it_has_a 'valid factory', :system_message
  it_has_a 'valid factory', :pha_message
  it_validates 'presence of', :system_event_template
  it_validates 'presence of', :type
  it_validates 'foreign key of', :content

  describe 'types' do
    describe ':system_message' do
      let(:system_action_template) { create(:system_action_template, :system_message) }

      it 'validates presence of message_text' do
        expect(system_action_template).to be_valid
        system_action_template.message_text = nil
        expect(system_action_template).to_not be_valid
        expect(system_action_template.errors[:message_text]).to include("can't be blank")
      end

      describe 'dynamic matchers' do
        it 'returns the correct matchers based on type' do
          expect(system_action_template).to be_system_message
          expect(system_action_template).to_not be_pha_message
        end
      end
    end

    describe ':pha_message' do
      let(:system_action_template) { create(:system_action_template, :pha_message) }

      it 'validates presence of message_text' do
        expect(system_action_template).to be_valid
        system_action_template.message_text = nil
        expect(system_action_template).to_not be_valid
        expect(system_action_template.errors[:message_text]).to include("can't be blank")
      end

      describe 'dynamic matchers' do
        it 'returns the correct matchers based on type' do
          expect(system_action_template).to_not be_system_message
          expect(system_action_template).to be_pha_message
        end
      end
    end
  end
end

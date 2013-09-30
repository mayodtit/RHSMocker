require 'spec_helper'

describe Consult do
  it_has_a 'valid factory'

  describe 'validations' do
    before(:each) do
      Consult.any_instance.stub(:set_defaults)
    end

    it_validates 'presence of', :title
    it_validates 'presence of', :initiator
    it_validates 'presence of', :subject
    it_validates 'presence of', :status
    it_validates 'presence of', :priority
    it_validates 'inclusion of', :checked
    it_validates 'length of', :users

    describe '#one_open_subject_per_initiator' do
      let!(:consult) { create(:consult) }

      it 'prevents the user from having two open consults' do
        new_consult = build_stubbed(:consult, :subject => consult.subject, :initiator => consult.initiator)
        new_consult.should_not be_valid
        new_consult.errors[:base].should include('You can only have one open consult per person in your family')
      end

      it 'allows one open and one closed consult for the same subject' do
        new_consult = build_stubbed(:consult, :subject => consult.subject,
                                              :initiator => consult.initiator,
                                              :status => :closed)
        new_consult.should be_valid
      end
    end
  end

  describe '#serializable_hash' do
    it 'includes #last_message_at by default' do
      build_stubbed(:consult).serializable_hash.should have_key(:last_message_at)
    end
  end
end

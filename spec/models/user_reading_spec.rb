require 'spec_helper'

describe UserReading do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'presence of', :content
  it_validates 'presence of', :viewed_count
  it_validates 'presence of', :saved_count
  it_validates 'presence of', :dismissed_count
  it_validates 'presence of', :shared_count

  describe 'incrementors' do
    let(:user) { create(:member) }
    let(:content) { create(:content) }

    describe '::increment_viewed!' do
      it 'increments viewed_count and saves the record' do
        ur = described_class.increment_viewed!(user, content)
        ur.viewed_count.should == 1
        ur.should be_persisted
      end
    end

    describe '::increment_saved!' do
      it 'increments saved_count and saves the record' do
        ur = described_class.increment_saved!(user, content)
        ur.saved_count.should == 1
        ur.should be_persisted
      end
    end

    describe '::increment_dismissed!' do
      it 'increments dismissed_count and saves the record' do
        ur = described_class.increment_dismissed!(user, content)
        ur.dismissed_count.should == 1
        ur.should be_persisted
      end
    end

    describe '::increment_shared!' do
      it 'increments shared_count and saves the record' do
        ur = described_class.increment_shared!(user, content)
        ur.shared_count.should == 1
        ur.should be_persisted
      end
    end
  end
end

require 'spec_helper'

describe UserReading do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'presence of', :content
  it_validates 'presence of', :view_count
  it_validates 'presence of', :save_count
  it_validates 'presence of', :dismiss_count
  it_validates 'presence of', :share_count

  describe 'incrementors' do
    let(:user) { create(:member) }
    let(:content) { create(:content) }

    describe '::increment_view!' do
      it 'increments view_count and saves the record' do
        ur = described_class.increment_view!(user, content)
        ur.view_count.should == 1
        ur.should be_persisted
      end
    end

    describe '::increment_save!' do
      it 'increments save_count and saves the record' do
        ur = described_class.increment_save!(user, content)
        ur.save_count.should == 1
        ur.should be_persisted
      end
    end

    describe '::increment_dismiss!' do
      it 'increments dismiss_count and saves the record' do
        ur = described_class.increment_dismiss!(user, content)
        ur.dismiss_count.should == 1
        ur.should be_persisted
      end
    end

    describe '::increment_share!' do
      it 'increments share_count and saves the record' do
        ur = described_class.increment_share!(user, content)
        ur.share_count.should == 1
        ur.should be_persisted
      end
    end
  end
end

require 'spec_helper'

describe Card do
  it_has_a 'valid factory'
  it_has_a 'valid factory', :saved
  it_has_a 'valid factory', :dismissed

  describe 'validations' do
    it_validates 'presence of', :user
    it_validates 'presence of', :resource
  end

  describe 'state machine' do
    describe 'states' do
      it 'sets the initial state to unsaved' do
        described_class.new.state?(:unsaved).should be_true
      end
    end

    describe 'events' do
      let!(:user) { create(:user) }

      describe 'saved' do
        it 'changes all to saved' do
          build(:card, :user => user).saved.should be_true
          build(:card, :saved, :user => user).saved.should be_true
          build(:card, :dismissed, :user => user).saved.should be_true
        end
      end

      describe 'dismissed' do
        it 'changes all to dismissed' do
          build(:card, :user => user).dismissed.should be_true
          build(:card, :saved, :user => user).dismissed.should be_true
          build(:card, :dismissed, :user => user).dismissed.should be_true
        end
      end

      describe 'reset' do
        it 'changes all to unsaved' do
          build(:card, :user => user).reset.should be_true
          build(:card, :saved, :user => user).reset.should be_true
          build(:card, :dismissed, :user => user).reset.should be_true
        end
      end
    end
  end

  describe 'scopes' do
    let!(:user) { create(:user) }
    let!(:unsaved) { create(:card, :user => user) }
    let!(:saved) { create(:card, :saved, :user => user) }
    let!(:dismissed) { create(:card, :dismissed, :user => user) }
    let!(:disease1) { create(:card, resource: (create :content, content_type: 'disease')) }
    let!(:disease2) { create(:card, resource: (create :content, content_type: 'Disease')) }

    describe '::inbox' do
      it 'returns unsaved cards' do
        results = described_class.inbox
        results.should =~ [unsaved]
        results.should_not include(saved, dismissed, disease1, disease2)
      end
    end

    describe '::timeline' do
      it 'returns saved cards' do
        results = described_class.timeline
        results.should =~ [saved]
        results.should_not include(unsaved, dismissed)
      end
    end
  end
end

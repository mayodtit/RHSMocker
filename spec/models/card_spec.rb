require 'spec_helper'

describe Card do
  it_has_a 'valid factory'
  it_has_a 'valid factory', :saved
  it_has_a 'valid factory', :dismissed
  it_has_a 'valid factory', :content_card
  it_has_a 'valid factory', :question_card
  it_has_a 'valid factory', :consult_card
  it_has_a 'valid factory', :consult_card_with_messages
  it_has_a 'valid factory', :custom
  it_has_a 'valid factory', :custom_with_content
  it_validates 'presence of', :user
  it_validates 'presence of', :resource
  it_validates 'foreign key of', :user_program
  it_validates 'foreign key of', :sender
  it_validates 'uniqueness of', :resource_id, :user_id, :resource_type

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

    describe '::inbox' do
      it 'returns unsaved cards' do
        results = described_class.inbox
        results.should =~ [unsaved]
        results.should_not include(saved, dismissed)
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

require 'spec_helper'

describe Card do
  it_has_a 'valid factory'
  it_validates 'presence of', :user

  describe 'state machine' do
    describe 'states' do
      it 'sets the initial state to unread' do
        described_class.new.state?(:unread).should be_true
      end

      describe 'read' do
        describe 'factory trait' do
          it 'builds a valid object' do
            build_stubbed(:card, :read).should be_valid
          end
        end
      end

      describe 'saved' do
        describe 'factory trait' do
          it 'builds a valid object' do
            build_stubbed(:card, :saved).should be_valid
          end
        end
      end

      describe 'dismissed' do
        describe 'factory trait' do
          it 'builds a valid object' do
            build_stubbed(:card, :dismissed).should be_valid
          end
        end
      end
    end

    describe 'events' do
      let!(:user) { create(:user) }

      describe 'read' do
        it 'changes unread to read' do
          build(:card, :with_timestamps).read.should be_true
        end

        it 'does not change read, saved, or dismissed state' do
          read = build(:card, :read, :with_timestamps, :user => user)
          read.read.should be_true
          read.read?.should be_true
          saved = build(:card, :saved, :with_timestamps, :user => user)
          saved.read.should be_true
          saved.saved?.should be_true
          dismissed = build(:card, :dismissed, :with_timestamps, :user => user)
          dismissed.read.should be_true
          dismissed.dismissed?.should be_true
        end
      end

      describe 'saved' do
        it 'changes all to saved' do
          build(:card, :with_timestamps, :user => user).saved.should be_true
          build(:card, :read, :with_timestamps, :user => user).saved.should be_true
          build(:card, :saved, :with_timestamps, :user => user).saved.should be_true
          build(:card, :dismissed, :with_timestamps, :user => user).saved.should be_true
        end
      end

      describe 'dismissed' do
        it 'changes all to dismissed' do
          build(:card, :with_timestamps, :user => user).dismissed.should be_true
          build(:card, :read, :with_timestamps, :user => user).dismissed.should be_true
          build(:card, :saved, :with_timestamps, :user => user).dismissed.should be_true
          build(:card, :dismissed, :with_timestamps, :user => user).dismissed.should be_true
        end
      end
    end
  end

  describe 'scopes' do
    let!(:user) { create(:user) }
    let!(:unread) { create(:card, :user => user) }
    let!(:read) { create(:card, :read, :user => user) }
    let!(:saved) { create(:card, :saved, :user => user) }
    let!(:dismissed) { create(:card, :dismissed, :user => user) }

    describe '::inbox' do
      it 'returns unread and read cards' do
        results = described_class.inbox
        results.should =~ [unread, read]
        results.should_not include(saved, dismissed)
      end
    end

    describe '::timeline' do
      it 'returns saved cards' do
        results = described_class.timeline
        results.should =~ [saved]
        results.should_not include(unread, read, dismissed)
      end
    end
  end
end

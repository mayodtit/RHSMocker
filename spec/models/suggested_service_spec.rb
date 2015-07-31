require 'spec_helper'

describe SuggestedService do
  it_has_a 'valid factory'
  it_has_a 'valid factory', :unoffered
  it_has_a 'valid factory', :offered
  it_has_a 'valid factory', :accepted
  it_has_a 'valid factory', :rejected
  it_has_a 'valid factory', :expired
  it_validates 'presence of', :user
  it_validates 'presence of', :suggested_service_template
  it_validates 'inclusion of', :user_facing

  describe 'state machine' do
    describe 'states' do
      describe '#user_facing_is_false' do
        it 'validates for all states except offer' do
          %i(unoffered accepted rejected expired).each do |state|
            suggested_service = build(:suggested_service, state, user_facing: true)
            expect(suggested_service).to_not be_valid
            expect(suggested_service.errors[:user_facing]).to include('must be false')
          end
        end
      end
    end

    describe 'audit trail' do
      let!(:suggested_service) { create(:suggested_service, :unoffered) }
      let!(:actor) { create(:pha) }

      it 'tracks state transitions with the actor' do
        expect do
          suggested_service.update_attributes(state_event: :offer, actor: actor)
        end.to change(SuggestedServiceChange, :count).by(1)

        change = suggested_service.reload.suggested_service_changes.last
        expect(change.event).to eq('offer')
        expect(change.from).to eq('unoffered')
        expect(change.to).to eq('offered')
        expect(change.actor).to eq(actor)
      end
    end
  end

  describe '#track_changes!' do
    let!(:suggested_service) { create(:suggested_service, :offered) }
    let!(:actor) { create(:pha) }

    it 'tracks changes to the model' do
      expect do
        suggested_service.update_attributes!(user_facing: true, actor: actor)
      end.to change(SuggestedServiceChange, :count).by(1)

      change = suggested_service.reload.suggested_service_changes.last
      expect(change.data).to eq({'user_facing' => [false, true]})
      expect(change.actor).to eq(actor)
    end
  end

  describe '#unset_user_facing' do
    context 'transitioning from user_facing = true' do
      let(:suggested_service) { create(:suggested_service, :offered, user_facing: true) }

      it 'sets user_facing to false for accept event' do
        expect(suggested_service.user_facing).to be_true
        suggested_service.update_attributes!(state_event: :accept, actor: suggested_service.user)
        expect(suggested_service.user_facing).to be_false
      end

      it 'sets user_facing to false for reject event' do
        expect(suggested_service.user_facing).to be_true
        suggested_service.update_attributes!(state_event: :accept, actor: suggested_service.user)
        expect(suggested_service.user_facing).to be_false
      end

      it 'sets user_facing to false for expire event' do
        expect(suggested_service.user_facing).to be_true
        suggested_service.update_attributes!(state_event: :expire, actor: suggested_service.user)
        expect(suggested_service.user_facing).to be_false
      end
    end
  end
end

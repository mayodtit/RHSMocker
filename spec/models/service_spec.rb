require 'spec_helper'

describe Service do
  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'presence of', :title
    it_validates 'presence of', :service_type
    it_validates 'presence of', :state
    it_validates 'presence of', :member
    it_validates 'presence of', :creator
    it_validates 'presence of', :owner
    it_validates 'presence of', :assignor

    its 'validates presence of assigned_at' do
      service = build_stubbed :service
      service.stub(:owner_id_changed?) { false }
      service.assigned_at = nil
      service.should_not be_valid
      service.errors[:assigned_at].should include("can't be blank")
    end

    context 'reason_abandoned' do
      let(:service) { build_stubbed :service }

      context 'service is abandoned' do
        before do
          service.stub(:abandoned?) { true }
        end

        it 'reason_abandoned should be present' do
          service.reason_abandoned = ''
          service.should_not be_valid
          service.errors[:reason_abandoned].should include("can't be blank")
        end
      end

      context 'service is not abandoned' do
        before do
          service.stub(:abandoned?) { false }
        end

        it 'reason_abandoned should be present' do
          service.reason_abandoned = nil
          service.should be_valid
        end
      end
    end
  end

  describe '#set_assigned_at' do
    let(:service) { build :service }

    before do
      Timecop.freeze
    end

    after do
      Timecop.return
    end

    context 'owner id changed' do
      before do
        service.stub(:owner_id_changed?) { true }
      end

      it 'sets assigned at' do
        service.set_assigned_at
        service.assigned_at.should == Time.now
      end
    end

    context 'owner id not changed' do
      before do
        service.assigned_at = nil
        service.stub(:owner_id_changed?) { false }
      end

      it 'sets assigned at to' do
        service.set_assigned_at
        service.assigned_at.should be_nil
      end
    end
  end

  context '#actor_id' do
    let(:service) { build :service }

    context '@actor_id is not nil' do
      before do
        service.instance_variable_set('@actor_id', 2)
      end

      it 'returns @actor_id' do
        service.actor_id.should == 2
      end
    end

    context 'actor_id is nil' do
      before do
        service.instance_variable_set('@actor_id', nil)
      end

      context 'owner_id is not nil' do
        before do
          service.stub(:owner_id) { 2 }
        end

        it 'returns owner_id' do
          service.actor_id.should == 2
        end
      end

      context 'owner_id is nil' do
        before do
          service.stub(:owner_id) { nil }
        end

        it 'returns creator id' do
          service.stub(:creator_id) { 3 }
          service.actor_id.should == 3
        end
      end
    end
  end
end

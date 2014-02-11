require 'spec_helper'

describe Api::V1::AssociationsController do
  let(:user) { build_stubbed(:member) }
  let(:association) { build_stubbed(:association, user: user) }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before do
    controller.stub(current_ability: ability)
    user.stub_chain(:associations, :find).and_return(association)
    association.stub(:invite!)
  end

  describe 'POST invite' do
    def do_request
      post :invite
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it 'calls invite! on the association' do
        association.should_receive(:invite!).once
        do_request
      end

      it_behaves_like 'success'
    end
  end
end

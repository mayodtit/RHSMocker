require 'spec_helper'

describe Api::V1::UserAgreementsController do
  let(:user) { build_stubbed(:member) }
  let(:agreement) { build_stubbed(:agreement) }
  let(:user_agreement) { build_stubbed(:user_agreement, user: user,
                                                        agreement: agreement) }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  describe 'POST create' do
    def do_request(params={user_agreement: {agreement_id: agreement.id}})
      post :create, params
    end

    let(:user_agreements) { double('user_agreements', create: user_agreement) }

    before do
      user.stub(user_agreements: user_agreements)
      user_agreement.stub(:reload)
    end

    it_behaves_like 'action requiring authentication'

    context 'authenticated', user: :authenticate! do
      it 'attempts to create the record' do
        user_agreements.should_receive(:create).once
        do_request
      end

      context 'save succeeds' do
        it_behaves_like 'success'

        it 'returns the user agreement' do
          do_request
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:user_agreement].to_json).to eq(user_agreement.as_json.to_json)
        end
      end

      context 'save fails' do
        before do
          user_agreement.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end
end

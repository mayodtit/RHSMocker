require 'spec_helper'

describe Api::V1::CustomCardsController do
  let(:user) { build_stubbed(:member) }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before do
    controller.stub(current_ability: ability)
  end

  context 'existing record' do
    let!(:custom_card) { create(:custom_card) }

    before do
      CustomCard.stub(find: custom_card)
    end


    describe 'GET inbox' do
      def do_request
        get :index, auth_token: user.auth_token
      end

      it_behaves_like 'action requiring authentication'

      context 'authenticated', user: :authenticate! do
        it_behaves_like 'success'

        it 'returns an array of custom_cards' do
          do_request
          json = JSON.parse(response.body)
          json['custom_cards'].to_json.should == [custom_card].serializer.as_json.to_json
        end
      end
    end

    describe 'GET show' do
      def do_request
        get :show, auth_token: user.auth_token
      end

      it_behaves_like 'action requiring authentication'

      context 'authenticated', user: :authenticate! do
        it_behaves_like 'success'

        it 'returns the custom_card' do
          do_request
          json = JSON.parse(response.body)
          json['custom_card'].to_json.should == custom_card.serializer(preview: true, raw_preview: true).as_json.to_json
        end
      end
    end

    describe 'PUT update' do
      def do_request
        put :update, auth_token: user.auth_token, custom_card: attributes_for(:custom_card)
      end

      before do
        custom_card.stub(:update_attributes)
      end

      it_behaves_like 'action requiring authentication'

      context 'authenticated', user: :authenticate! do
        it 'attempts to update the record' do
          custom_card.should_receive(:update_attributes).once
          do_request
        end

        context 'update_attributes succeeds' do
          before do
            custom_card.stub(update_attributes: true)
          end

          it_behaves_like 'success'
        end

        context 'update_attributes fails' do
          before do
            custom_card.stub(update_attributes: false)
            custom_card.errors.add(:base, :invalid)
          end

          it_behaves_like 'failure'
        end
      end
    end
  end

  describe 'POST create' do
    def do_request
      post :create, custom_card: attributes_for(:custom_card)
    end

    let(:custom_card) { build_stubbed(:custom_card) }

    before do
      CustomCard.stub(:create => custom_card)
    end

    it_behaves_like 'action requiring authentication'

    context 'authenticated', user: :authenticate! do
      it 'attempts to create the record' do
        CustomCard.should_receive(:create).once
        do_request
      end

      context 'save succeeds' do
        it_behaves_like 'success'

        it 'returns the custom_card' do
          do_request
          json = JSON.parse(response.body)
          json['custom_card'].to_json.should == custom_card.serializer.as_json.to_json
        end
      end

      context 'save fails' do
        before(:each) do
          custom_card.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end
end

require 'spec_helper'
require 'stripe_mock'

describe Api::V1::MembersController do
  let(:user) { build_stubbed(:member) }
  let(:ability) { Object.new.extend(CanCan::Ability) }
  let(:results) { [user] }

  before do
    controller.stub(current_ability: ability)
    Member.stub(find: user)
  end

  describe 'GET index' do
    def do_request(params={})
      get :index, params
    end

    before do
      Member.stub_chain(:page, :per).and_return(results)
      results.stub(total_count: 1)
      results.stub(:includes).and_return(results)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns an array of members as users' do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        body[:users].to_json.should == [user].serializer(list: true).as_json.to_json
      end

      context 'with a query param' do
        it 'searches by name and returns an array of members as users' do
          Member.should_receive(:name_search).once.and_return(Member)
          do_request(q: user.first_name)
          body = JSON.parse(response.body, symbolize_names: true)
          body[:users].to_json.should == [user].serializer(list: true).as_json.to_json
        end
      end

      context 'with a pha_id param' do
        it 'searches by pha_id' do
          Member.stub(:name_search).and_return(Member)
          Member.stub(:signed_up).and_return(Member)
          Member.should_receive(:where).with('pha_id' => '1').once.and_return(Member)
          do_request(q: user.first_name, pha_id: 1)
          body = JSON.parse(response.body, symbolize_names: true)
          body[:users].to_json.should == [user].serializer(list: true).as_json.to_json
        end
      end
    end
  end

  describe 'GET show' do
    def do_request
      get :show
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns the member' do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        body[:user].to_json.should == user.serializer.as_json.to_json
      end
    end
  end

  describe 'GET current' do
    def do_request
      get :current
    end

    it_behaves_like 'action requiring authentication'

    context 'authenticated', user: :authenticate! do
      it_behaves_like 'success'

      it 'returns the current_user' do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        body[:user].to_json.should == user.serializer(include_roles: true).as_json.to_json
      end
    end
  end

  describe 'POST create' do
    def do_request(params={})
      post :create, user: attributes_for(:member).merge!(params)
    end

    before do
      user.stub(:reload) { user }
      user.stub(:update_attribute)
      Member.stub(create: user)
      StripeMock.start
      Stripe::Plan.create(amount: 1999,
                          interval: :month,
                          name: 'Single Membership',
                          currency: :usd,
                          id: 'bp20')
    end

    it 'attempts to create the record' do
      Member.should_receive(:create).once
      do_request
    end

    context 'save succeeds' do
      it_behaves_like 'success'

      it 'returns the member' do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        body[:user].to_json.should == user.serializer.as_json.to_json
      end

      it "returns the session's auth_token" do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        body[:auth_token].to_json.should == user.sessions.first.auth_token.to_json
      end

      it 'render readable message to user when haveing Stripe::CardError card_declined' do
        StripeMock.prepare_card_error(:card_declined, :new_customer)
        do_request(payment_token: StripeMock.generate_card_token(last4: "0002", exp_year: 1984))
        response.should_not be_success
        response.status.should == 422
        JSON.parse(response.body)['reason'].should == "card_declined"
        JSON.parse(response.body)['user_message'].should == "The card was declined"
      end

      it 'render readable message to user when haveing Stripe::CardError incorrect_number' do
        StripeMock.prepare_card_error(:incorrect_number, :new_customer)
        do_request(payment_token: StripeMock.generate_card_token(last4: "0002", exp_year: 1984))
        response.should_not be_success
        response.status.should == 422
        JSON.parse(response.body)['reason'].should == "incorrect_number"
        JSON.parse(response.body)['user_message'].should == "The card number is incorrect"
      end

      it 'render readable message to user when haveing Stripe::CardError invalid_number' do
        StripeMock.prepare_card_error(:invalid_number, :new_customer)
        do_request(payment_token: StripeMock.generate_card_token(last4: "0002", exp_year: 1984))
        response.should_not be_success
        response.status.should == 422
        JSON.parse(response.body)['reason'].should == "invalid_number"
        JSON.parse(response.body)['user_message'].should == "The card number is not a valid credit card number"
      end

      it 'render readable message to user when haveing Stripe::CardError invalid_expiry_month' do
        StripeMock.prepare_card_error(:invalid_expiry_month, :new_customer)
        do_request(payment_token: StripeMock.generate_card_token(last4: "0002", exp_year: 1984))
        response.should_not be_success
        response.status.should == 422
        JSON.parse(response.body)['reason'].should == "invalid_expiry_month"
        JSON.parse(response.body)['user_message'].should == "The card's expiration month is invalid"
      end

      it 'render readable message to user when haveing Stripe::CardError invalid_expiry_year' do
        StripeMock.prepare_card_error(:invalid_expiry_year, :new_customer)
        do_request(payment_token: StripeMock.generate_card_token(last4: "0002", exp_year: 1984))
        response.should_not be_success
        response.status.should == 422
        JSON.parse(response.body)['reason'].should == "invalid_expiry_year"
        JSON.parse(response.body)['user_message'].should == "The card's expiration year is invalid"
      end

      it 'render readable message to user when haveing Stripe::CardError invalid_cvc' do
        StripeMock.prepare_card_error(:invalid_cvc, :new_customer)
        do_request(payment_token: StripeMock.generate_card_token(last4: "0002", exp_year: 1984))
        response.should_not be_success
        response.status.should == 422
        JSON.parse(response.body)['reason'].should == "invalid_cvc"
        JSON.parse(response.body)['user_message'].should == "The card's security code is invalid"
      end

      it 'render readable message to user when haveing Stripe::CardError expired_card' do
        StripeMock.prepare_card_error(:expired_card, :new_customer)
        do_request(payment_token: StripeMock.generate_card_token(last4: "0002", exp_year: 1984))
        response.should_not be_success
        response.status.should == 422
        JSON.parse(response.body)['reason'].should == "expired_card"
        JSON.parse(response.body)['user_message'].should == "The card has expired"
      end

      it 'render readable message to user when haveing Stripe::CardError incorrect_cvc' do
        StripeMock.prepare_card_error(:incorrect_cvc, :new_customer)
        do_request(payment_token: StripeMock.generate_card_token(last4: "0002", exp_year: 1984))
        response.should_not be_success
        response.status.should == 422
        JSON.parse(response.body)['reason'].should == "incorrect_cvc"
        JSON.parse(response.body)['user_message'].should == "The card's security code is incorrect"
      end

      it 'render readable message to user when haveing Stripe::CardError processing_error' do
        StripeMock.prepare_card_error(:processing_error, :new_customer)
        do_request(payment_token: StripeMock.generate_card_token(last4: "0002", exp_year: 1984))
        response.should_not be_success
        response.status.should == 422
        JSON.parse(response.body)['reason'].should == "processing_error"
        JSON.parse(response.body)['user_message'].should == "An error occurred while processing the card"
      end

      it 'render readable message to user when haveing errors other than Stripe::CardError' do
        custom_error = Stripe::StripeError.new("API error")
        StripeMock.prepare_error(custom_error, :new_customer)
        do_request(payment_token: StripeMock.generate_card_token(last4: "0002", exp_year: 1984))
        response.should_not be_success
        response.status.should == 422
        JSON.parse(response.body)['reason'].should == "API error"
        JSON.parse(response.body)['user_message'].should == "There's an error with your credit card, please try another one"
      end
    end

    context 'save fails' do
      before do
        user.errors.add(:base, :invalid)
      end

      it_behaves_like 'failure'
    end

    after do
      StripeMock.stop
    end
  end

  describe 'PUT update' do
    def do_request
      put :update, user: attributes_for(:user)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it 'attempts to update the record' do
        user.should_receive(:update_attributes).once
        do_request
      end

      context 'update_attributes succeeds' do
        before do
          user.stub(update_attributes: true)
        end

        it_behaves_like 'success'

        it 'returns the member' do
          do_request
          body = JSON.parse(response.body, symbolize_names: true)
          body[:user].to_json.should == user.serializer.as_json.to_json
        end
      end

      context 'update_attributes fails' do
        before do
          user.stub(update_attributes: false)
          user.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end

  describe 'PUT secure_update' do
    def do_request
      put :secure_update, user: attributes_for(:user).merge!(current_password: 'password')
    end

    before do
      request.env['PATH_INFO'] = 'controller_path'
    end

    it_behaves_like 'action requiring authentication'

    context 'authenticated', user: :authenticate! do
      before do
        controller.stub(login: false)
      end

      it_behaves_like 'failure'

      context 'password authenticated' do
        before do
          controller.stub(login: user)
        end

        it_behaves_like 'action requiring authorization'

        context 'authorized', user: :authorize! do
          it 'attempts to update the record' do
            user.should_receive(:update_attributes).once
            do_request
          end

          context 'update_attributes succeeds' do
            before do
              user.stub(update_attributes: true)
            end

            it_behaves_like 'success'
          end

          context 'update_attributes fails' do
            before do
              user.stub(update_attributes: false)
              user.errors.add(:base, :invalid)
            end

            it_behaves_like 'failure'
          end
        end
      end
    end
  end
end

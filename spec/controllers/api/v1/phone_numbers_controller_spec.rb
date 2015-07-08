require "spec_helper"

describe Api::V1::PhoneNumbersController do
  let(:phone_number_attributes) { { number: "4251234567", primary: true, type: "Home" } }
  let(:user) do
    u = create(:user).tap{|u| u.phone_numbers.create(phone_number_attributes) }
  end
  let(:phone_number) { user.phone_numbers.first }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before do
    controller.stub(current_ability: ability)
  end

  describe "GET index" do
    def do_request
      get :index, user_id: user.id
    end

    it_behaves_like "action requiring authentication and authorization"

    context "authenticated and authorized", user: :authenticate_and_authorize! do
      it_behaves_like "success"

      it "returns an array of PhoneNumbers" do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:phone_numbers].to_json).to eq([phone_number].serializer.as_json.to_json)
      end
    end
  end

  describe "POST create" do
    let(:work_phone_number_attributes) { phone_number_attributes.merge({type: "Work"}) }
    def do_request
      post :create, user_id: user.id, phone_number: work_phone_number_attributes
    end

    before do
      PhoneNumber.stub(create: phone_number,
                       find: phone_number)
    end

    it_behaves_like "action requiring authentication and authorization"

    context "authenticated and authorized", user: :authenticate_and_authorize! do
      it_behaves_like "success"

      it "returns the new PhoneNumber" do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:phone_number].to_json).to eq(phone_number.serializer.as_json.to_json)
      end
    end
  end

  describe "GET show"
  describe "PUT update"
  describe "DELETE destroy"
end

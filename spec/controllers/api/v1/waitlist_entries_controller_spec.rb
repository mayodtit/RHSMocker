require 'spec_helper'

describe Api::V1::WaitlistEntriesController do
  let(:user) { build_stubbed(:admin) }
  let(:waitlist_entry) { build_stubbed(:waitlist_entry) }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before do
    controller.stub(current_ability: ability)
  end

  describe 'GET index' do
    def do_request
      get :index
    end

    before do
      WaitlistEntry.stub(all: [waitlist_entry])
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it_behaves_like 'success'

      it "returns an array of WaitlistEntries" do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:waitlist_entries].to_json).to eq([waitlist_entry].as_json.to_json)
      end
    end
  end

  describe 'POST create' do
    def do_request
      post :create, waitlist_entry: attributes_for(:waitlist_entry)
    end

    before do
      WaitlistEntry.stub(create: waitlist_entry)
    end

    it 'attempts to create the record' do
      WaitlistEntry.should_receive(:create).once
      do_request
    end

    context 'save succeeds' do
      it_behaves_like 'success'

      it 'returns the waitlist_entry' do
        do_request
        json = JSON.parse(response.body)
        json['waitlist_entry'].to_json.should == waitlist_entry.as_json.to_json
      end
    end

    context 'save fails' do
      before do
        waitlist_entry.errors.add(:base, :invalid)
      end

      it_behaves_like 'failure'
    end

    context 'admin logged in', user: :authenticate! do
      def do_request
        post :create, auth_token: user.auth_token
      end

      it_behaves_like 'action requiring authorization'

      context 'authorized', user: :authorize! do
        it 'attempts to create the record' do
          WaitlistEntry.should_receive(:create).once
          do_request
        end

        context 'save succeeds' do
          it_behaves_like 'success'

          it 'returns the waitlist_entry' do
            do_request
            json = JSON.parse(response.body)
            json['waitlist_entry'].to_json.should == waitlist_entry.as_json.to_json
          end
        end

        context 'save fails' do
          before do
            waitlist_entry.errors.add(:base, :invalid)
          end

          it_behaves_like 'failure'
        end
      end
    end
  end
end

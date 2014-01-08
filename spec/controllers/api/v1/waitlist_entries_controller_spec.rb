require 'spec_helper'

describe Api::V1::WaitlistEntriesController do
  let(:waitlist_entry) { build_stubbed(:waitlist_entry) }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before do
    controller.stub(current_ability: ability)
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
  end
end

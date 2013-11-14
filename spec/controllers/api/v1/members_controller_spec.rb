require 'spec_helper'

describe Api::V1::MembersController do
  let(:user) { build_stubbed(:member) }
  let(:ability) { Object.new.extend(CanCan::Ability) }
  let(:results) { [user] }

  before do
    controller.stub(current_ability: ability)
    Member.stub_chain(:page, :per).and_return(results)
    results.stub(total_count: 1)
  end

  describe 'GET index' do
    def do_request(params={})
      get :index, {auth_token: user.auth_token}.merge!(params)
    end

    it_behaves_like 'action requiring authentication'

    context 'authenticated', user: :authenticate! do
      it_behaves_like 'success'

      it 'returns an array of members as users' do
        do_request
        json = JSON.parse(response.body)
        json['users'].to_json.should == [user.as_json].to_json
      end

      context 'with a query param' do
        it 'searches by name and returns an array of members as users' do
          Member.should_receive(:name_search).once.and_return(Member)
          do_request(q: user.first_name)
          json = JSON.parse(response.body)
          json['users'].to_json.should == [user.as_json].to_json
        end
      end
    end
  end
end

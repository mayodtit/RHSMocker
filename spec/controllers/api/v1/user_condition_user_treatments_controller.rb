require 'spec_helper'

describe Api::V1::UserConditionUserTreatmentsController do
  let(:user) { build_stubbed(:user) }
  let(:ability) { Object.new.extend(CanCan::Ability) }
  let(:user_condition) { build_stubbed(:user_condition, :user => user) }
  let(:user_treatment) { build_stubbed(:user_treatment, :user => user) }
  let(:user_condition_user_treatment) { build_stubbed(:user_condition_user_treatment,
                                                    :user_condition => user_condition,
                                                    :user_treatment => user_treatment) }
  let(:user_conditions) { double('user_conditions', :find => user_condition) }
  let(:user_treatments) { double('user_treatments', :find => user_treatment) }

  before(:each) do
    controller.stub(:current_ability => ability)
    user.stub(:user_conditions => user_conditions)
    user.stub(:user_treatments => user_treatments)
    UserConditionUserTreatment.stub_chain(:where, :first!).and_return(user_condition_user_treatment)
  end

  describe 'POST create' do
    def do_request
      post :create
    end

    before(:each) do
      UserConditionUserTreatment.stub(:create => user_condition_user_treatment)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to create the record' do
        UserConditionUserTreatment.should_receive(:create).once
        do_request
      end

      context 'save succeeds' do
        it_behaves_like 'success'

        it 'returns the record' do
          do_request
          json = JSON.parse(response.body)
          json['user_condition_user_treatment'].to_json.should == user_condition_user_treatment.as_json.to_json
        end
      end

      context 'save fails' do
        before(:each) do
          user_condition_user_treatment.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end

  describe 'DELETE destroy' do
    def do_request
      delete :destroy
    end

    before(:each) do
      user_condition_user_treatment.stub(:destroy)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to destroy the record' do
        user_condition_user_treatment.should_receive(:destroy).once
        do_request
      end

      context 'destroy succeeds' do
        before(:each) do
          user_condition_user_treatment.stub(:destroy => true)
        end

        it_behaves_like 'success'
      end

      context 'destroy fails' do
        before(:each) do
          user_condition.stub(:destroy => false)
          user_condition.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end
end

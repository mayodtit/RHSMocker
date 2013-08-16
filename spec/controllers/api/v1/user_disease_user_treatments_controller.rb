require 'spec_helper'

describe Api::V1::UserDiseaseUserTreatmentsController do
  let(:user) { build_stubbed(:user) }
  let(:ability) { Object.new.extend(CanCan::Ability) }
  let(:user_disease) { build_stubbed(:user_disease, :user => user) }
  let(:user_disease_treatment) { build_stubbed(:user_disease_treatment, :user => user) }
  let(:user_disease_user_treatment) { build_stubbed(:user_disease_user_treatment,
                                                    :user_disease => user_disease,
                                                    :user_disease_treatment => user_disease_treatment) }
  let(:user_diseases) { double('user_diseases', :find => user_disease) }
  let(:user_disease_treatments) { double('user_disease_treatments', :find => user_disease_treatment) }

  before(:each) do
    controller.stub(:current_ability => ability)
    user.stub(:user_diseases => user_diseases)
    user.stub(:user_disease_treatments => user_disease_treatments)
    UserDiseaseUserTreatment.stub_chain(:where, :first!).and_return(user_disease_user_treatment)
  end

  describe 'POST create' do
    def do_request
      post :create
    end

    before(:each) do
      UserDiseaseUserTreatment.stub(:create => user_disease_user_treatment)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to create the record' do
        UserDiseaseUserTreatment.should_receive(:create).once
        do_request
      end

      context 'save succeeds' do
        it_behaves_like 'success'

        it 'returns the record' do
          do_request
          json = JSON.parse(response.body)
          json['user_disease_user_treatment'].to_json.should == user_disease_user_treatment.as_json.to_json
        end
      end

      context 'save fails' do
        before(:each) do
          user_disease_user_treatment.errors.add(:base, :invalid)
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
      user_disease_user_treatment.stub(:destroy)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it 'attempts to destroy the record' do
        user_disease_user_treatment.should_receive(:destroy).once
        do_request
      end

      context 'destroy succeeds' do
        before(:each) do
          user_disease_user_treatment.stub(:destroy => true)
        end

        it_behaves_like 'success'
      end

      context 'destroy fails' do
        before(:each) do
          user_disease.stub(:destroy => false)
          user_disease.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end
end

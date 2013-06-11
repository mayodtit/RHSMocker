require 'spec_helper'

describe UserDisease do
  let(:user_disease) { build(:user_disease) }

  describe 'factory' do
    it 'creates valid objects' do
      user_disease.should be_valid
      user_disease.save.should be_true
      user_disease.should be_persisted
    end

    describe 'trait diagnosed' do
      let(:diagnosed_user_disease) { build(:user_disease, :diagnosed) }

      it 'creates valid objects' do
        diagnosed_user_disease.should be_valid
      end

      it 'creates diagnosed objects' do
        diagnosed_user_disease.diagnosed.should be_true
      end
    end
  end

  describe 'validations' do
    context 'diagnosed' do
      let(:diagnosed_user_disease) { build(:user_disease, :diagnosed) }

      it 'requires diagnoser' do
        diagnosed_user_disease.should be_valid
        diagnosed_user_disease.diagnoser.should_not be_nil
        diagnosed_user_disease.diagnoser = nil
        diagnosed_user_disease.should_not be_valid
      end

      it 'requires diagnosed_date' do
        diagnosed_user_disease.should be_valid
        diagnosed_user_disease.diagnosed_date.should_not be_nil
        diagnosed_user_disease.diagnosed_date = nil
        diagnosed_user_disease.should_not be_valid
      end
    end
  end
end

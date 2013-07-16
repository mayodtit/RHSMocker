require 'spec_helper'

describe UserDisease do
  it_has_a 'valid factory'

  describe 'diagnosed' do
    describe 'factory trait' do
      let(:diagnosed_user_disease) { build_stubbed(:user_disease, :diagnosed) }

      it 'creates valid objects' do
        diagnosed_user_disease.should be_valid
      end

      it 'creates diagnosed objects' do
        diagnosed_user_disease.diagnosed.should be_true
      end
    end

    describe 'validations' do
      it 'requires diagnoser' do
        build_stubbed(:user_disease, :diagnosed, :diagnoser => nil).should_not be_valid
      end

      it 'requires diagnosed_date' do
        build_stubbed(:user_disease, :diagnosed, :diagnosed_date => nil).should_not be_valid
      end
    end
  end
end

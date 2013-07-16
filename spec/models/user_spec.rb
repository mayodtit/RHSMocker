require 'spec_helper'

describe User do
  let(:user) { build(:user) }

  # TODO - this is a hack to eliminate false positives resulting from dirty database
  before(:each) do
    User.delete_all
  end

  it_has_a 'valid factory'

  describe '#age' do
    let!(:no_birthday_user) { build_stubbed(:user, :birth_date => nil) }
    let!(:baby_user) { build_stubbed(:user, :birth_date => 11.months.ago) }
    let!(:yr_user) { build_stubbed(:user, :birth_date => 13.months.ago) } 
    let!(:adult_user) { build_stubbed(:user, :birth_date => 360.months.ago) }
    #let(:user) { blood_pressure.user }

    it 'correctly handles from basic birthdate' do
      adult_user.age.should == 30
    end

    it 'correctly handles empty birthday in age' do
      no_birthday_user.age.should be_nil
    end

    it 'correctly handles less than 1 year' do
      baby_user.age.should == 0
    end

    it 'correctly handles just over a year' do
      yr_user.age.should == 1
    end

  end
end

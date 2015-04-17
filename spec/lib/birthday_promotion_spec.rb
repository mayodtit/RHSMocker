require 'spec_helper'

describe BirthdayPromotion do
  describe 'Promote free member' do
    
    let!(:member) { create :member }
    let!(:birthday_promotion) { create(:promotion, :name => 'Birthday Promotion') }

    context 'user has not had a previous promotion' do
      it 'should give user a promotion' do
        BirthdayPromotion.new(member).promote
        member.status.should == 'trial'
      end
    end

    context 'user has had a previous promotion' do
      let!(:user_promotion) { create :user_promotion, promotion: birthday_promotion, user: member }
      it 'should not give user promotion' do
        BirthdayPromotion.new(member).promote
        member.status.should == 'free'
      end
    end
  end
end

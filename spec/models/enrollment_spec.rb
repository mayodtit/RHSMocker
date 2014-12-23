require 'spec_helper'

describe Enrollment do
  it_has_a 'valid factory'

  describe 'presence validations' do
    before do
      described_class.any_instance.stub(:set_token)
    end
    it_validates 'presence of', :token
  end

  it_validates 'foreign key of', :user
  it_validates 'foreign key of', :onboarding_group
  it_validates 'foreign key of', :referral_code
  it_validates 'uniqueness of', :token
  it_validates 'allows blank uniqueness of', :email

  it 'validates length of password' do
    e = build_stubbed(:enrollment, password: 'short')
    expect(e).to_not be_valid
    expect(e.errors[:password]).to include('must be 8 or more characters long')
  end

  it 'validates email not taken by member' do
    m = create(:member)
    e = build_stubbed(:enrollment, email: m.email)
    expect(e).to_not be_valid
    expect(e.errors[:email]).to include('account already exists')
  end
end

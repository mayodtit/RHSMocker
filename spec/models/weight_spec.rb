require 'spec_helper'

describe Weight do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'presence of', :amount
  it_validates 'presence of', :taken_at
  it_validates 'numericality of', :amount

  describe '::most_recent' do
    let!(:weight) { create(:weight) }
    let!(:other_weight) { create(:weight,
                                 user: weight.user,
                                 taken_at: weight.taken_at - 1.day) }

    it 'returns the most recent weight for a given user' do
      expect(described_class.most_recent).to eq(weight)
    end
  end
end

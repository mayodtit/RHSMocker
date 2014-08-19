require 'spec_helper'

describe NuxAnswer do
  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'presence of', :name
    it_validates 'presence of', :text
    it_validates 'presence of', :ordinal
    it_validates 'presence of', :phrase
  end

  describe 'active' do
    let!(:active_a) { create :nux_answer, ordinal: 1 }
    let!(:active_b) { create :nux_answer, ordinal: 2 }
    let!(:active_c) { create :nux_answer, ordinal: 0 }
    let!(:inactive) { create :nux_answer, ordinal: 3, active: false }

    it 'filters out inactive answers' do
      NuxAnswer.active.should == [active_b, active_a, active_c]
    end
  end
end

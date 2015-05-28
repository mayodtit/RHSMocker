require 'spec_helper'

describe WeightSerializer do
  context 'with a bmi and bmi_level' do
    let(:weight) { create(:weight, bmi: 12, bmi_level: 'Severely Underweight') }

    it 'renders bmi related attributes' do
      result = weight.serializer.as_json
      expect(result[:bmi]).to eq(12)
      expect(result[:bmi_level]).to eq('Severely Underweight')
      expect(result[:warning_color]).to eq('#FF3A30')
      expect(result[:bmi_warning_level]).to eq('severely-underweight')
      expect(result[:bmi_warning_level_display]).to eq('Severely Underweight')
      expect(result[:bmi_warning_level_display_level]).to eq('severe')
    end
  end
end

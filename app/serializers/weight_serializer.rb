class WeightSerializer < ActiveModel::Serializer
  self.root = false

  has_one :creator
  attributes :id, :user_id, :amount, :bmi, :taken_at, :healthkit_uuid, :bmi_level,
             :healthkit_source, :creator_id, :warning_color

  def warning_color
    if bmi_level == "Severely Underweight" || bmi_level == "Obese"
      "#FF3A30" # Red color Hex Code
    elsif bmi_level == "Overweight" || bmi_level == "Underweight"
      "#FFC85A" # Yellow color Hex Code
    elsif bmi_level == "Normal"
      "#6A9B6B" # Green color Hex Code
    end
  end

end

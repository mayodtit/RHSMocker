class WeightSerializer < ActiveModel::Serializer
  self.root = false

  has_one :creator
  attributes :id, :user_id, :amount, :bmi, :taken_at, :healthkit_uuid, :bmi_level,
             :healthkit_source, :creator_id, :warning_color

  def warning_color
    case bmi_level
    when "Severely Underweight", "Obese"
      "#FF3A30" # Red color Hex Code
    when "Overweight", "Underweight"
      "#FFC85A" # Yellow color Hex Code
    when "Normal"
      "#6A9B6B" # Green color Hex Code
    end
  end

  def bmi
    object.bmi.round(1)
  end
end

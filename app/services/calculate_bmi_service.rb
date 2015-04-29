require 'csv'

class CalculateBmiService
  def initialize(options)
    @height = options[:height]
    @weight = options[:weight]
    @birth_date = options[:birth_date]
    @gender = if options[:gender] == "male" then 1 else 2
              end
  end

  def call
    {
      bmi: bmi,
      bmi_level: bmi_level,
      warning_color: warning_color
    }
  end

  private

  def bmi
    @bmi ||= @weight.amount / ((@height.amount / 100.0) * (@height.amount / 100.0))
  end

  def bmi_level
    if age > 0 && age < (18 * 12)
      if z_score < 4
        @bmi_level = "Severely Underweight"
      elsif z_score < 5
        @bmi_level = "Underweight"
      elsif z_score < 85
        @bmi_level = "Normal"
      elsif z_score < 95
        @bmi_level = "Overweight"
      end
    else
      if (bmi < 15)
        @bmi_level = "Severely Underweight"
      elsif (bmi < 18.5)
        @bmi_level = "Underweight"
      elsif (bmi < 24.9)
        @bmi_level = "Normal"
      elsif (bmi < 29.9)
        @bmi_level = "Overweight"
      else
        @bmi_level = "Obese"
      end
    end
  end

  def z_score
    @z_score = if bmi_record.power_in_transformation != 0
                 (((bmi / bmi_record.median) ** bmi_record.power_in_transformation)-1) / (bmi_record.power_in_transformation * bmi_record.coefficient_of_variation)
               else
                 Math.log(bmi / bmi_record.median) / bmi_record.coefficient_of_variation
               end
  end

  def age
    @age = Time.now - @birth_date.to_time
    @age = @age/(60*60*24*30)
    @age
  end

  def bmi_record
    @bmi_record ||= BmiDataLevel.find_by_gender_and_age_in_months!(@gender, age.round)
  end

  def warning_color
    @warning_color = if bmi_level == "Severely Underweight" || bmi_level == "Obese"
                       "#FF3A30" # Red color Hex Code
                     elsif bmi_level == "Overweight" || bmi_level == "Underweight"
                       "#FFC85A" # Yellow color Hex Code
                     elsif bmi_level == "Normal"
                       "#6A9B6B" # Green color Hec Code
                     end
  end
end

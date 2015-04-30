class CalculateBmiService
  def initialize(options)
    @height = options[:height]
    @weight = options[:weight]
    @birth_date = options[:birth_date]
    @gender = options[:gender] == 'male' ? 1 : 2
  end

  def call
    raise "Preconditions not satisfied to calculate BMI or BMI level" unless (@height && @weight && @birth_date && @gender)
    {
      bmi: bmi,
      bmi_level: bmi_level
    }
  end

  private

  def bmi
    @bmi ||= @weight.amount / ((@height.amount / 100.0) * (@height.amount / 100.0))
  end

  def bmi_level
    if age_in_months > 0 && age_in_months < (18 * 12)
      bmi_level_for_child
    else
      bmi_level_for_adult
    end
  end

  def bmi_level_for_child
    @bmi_level_for_child ||= if z_score < 4
                               "Severely Underweight"
                             elsif z_score < 5
                               "Underweight"
                             elsif z_score < 85
                               "Normal"
                             elsif z_score < 95
                               "Overweight"
                             end
  end

  def bmi_level_for_adult
    @bmi_level_for_adult ||= if (bmi < 15)
                               "Severely Underweight"
                             elsif (bmi < 18.5)
                               "Underweight"
                             elsif (bmi < 24.9)
                               "Normal"
                             elsif (bmi < 29.9)
                               "Overweight"
                             else
                               "Obese"
                             end
  end

  def z_score
    @z_score = if bmi_record.power_in_transformation != 0
                 (((bmi / bmi_record.median) ** bmi_record.power_in_transformation)-1) / (bmi_record.power_in_transformation * bmi_record.coefficient_of_variation)
               else
                 Math.log(bmi / bmi_record.median) / bmi_record.coefficient_of_variation
               end
  end

  SECONDS_PER_MONTH = 60 * 60 * 24 * 30

  def age_in_months
    @age_in_months ||= (Time.now - @birth_date.to_time) / SECONDS_PER_MONTH
  end

  def bmi_record
    @bmi_record ||= BmiDataLevel.find_by_gender_and_age_in_months!(@gender, age.round)
  end
end

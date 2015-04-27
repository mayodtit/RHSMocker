require 'csv'

class CalculateBmiService
  def initialize(options)
    @height = options[:height]
    @weight = options[:weight]
    @birth_date = options[:birth_date]
    @gender = options[:gender]
  end

  def call
    {
      bmi: bmi,
      bmi_level: bmi_level
    }
  end

  def bmi
    @bmi = @weight/((@height/100.0)*(@height/100.0))
    @bmi
  end

  def bmi_level
    if age > 0 && age < (18*12)
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
      if (@bmi < 15)
        @bmi_level = "Severely Underweight"
      elsif (@bmi < 18.5)
        @bmi_level = "Underweight"
      elsif (@bmi < 24.9)
        @bmi_level = "Normal"
      elsif (@bmi < 29.9)
        @bmi_level = "Overweight"
      else
        @bmi_level = "Obese"
      end
    end
    @bmi_level
  end

  def z_score
    look_up_LMS
    @z_score = if @bmi_record.l != 0
                 (((@bmi/@bmi_record.m)**@bmi_record.l)-1)/(@bmi_record.l*@bmi_record.s)
               else
                 Math.log((@bmi/@bmi_record.m))/@bmi_record.s
               end
  end

  def age
    @age = Time.now - @birth_date.to_time
    @age = @age/(60*60*24*30)
    @age
  end

  def look_up_LMS
    if @gender == "male"
      @bmi_record = BmiDataLevel.where(gender:1, age: age.round).first
    else
      @bmi_record = BmiDataLevel.where(gender:2, age: age.round).first
    end
  end
end

class CalculateBmiService
  def initialize(options)
    @height = options[:height]
    @weight = options[:weight]
  end

  def call
    {
      bmi: 123,
      bmi_level: :overweight
    }
  end
end

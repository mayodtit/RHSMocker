class UserWeight < ActiveRecord::Base
  attr_accessible :user, :weight, :bmi

  belongs_to :user

  validates :weight, :presence => true

  after_create do |variable|
    self.updateBMI
  end

  #Check writes
  #convert to lbs and inches?

  #Metric BMI is kg/m(2)
  def updateBMI
    if (!user.height.nil?)
      heightInMeters = self.user.height * 0.01
      if (user.height > 0) && (weight > 0)
        self.bmi = self.weight / (heightInMeters * heightInMeters)
        save!
      end
    end
  end

  #Braindamage - move to a utilities class
  def metersForInches(inches)
    meters = inches * 0.0254
  end

  def inchesForMeters(meters)
    inches = meters * 39.3701
  end

  def poundsForKg(kg)
    lbs = kg * 2.2
  end

  def kgForPounds(lbs)
    kg = lbs / 2.2
  end

end

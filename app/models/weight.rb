#Amount is in Kilograms
class Weight < ActiveRecord::Base
  belongs_to :user
  belongs_to :creator, class_name: 'Member'

  attr_accessible :user, :user_id, :amount, :bmi, :taken_at, :healthkit_uuid,
                  :healthkit_source, :creator_id, :creator, :bmi_level

  validates :user, :amount, :taken_at, :bmi, :bmi_level, presence: true

  before_validation :set_defaults, on: :create
  before_validation :set_bmi_values

  def self.most_recent
    order('taken_at DESC').first
  end

  private

  def set_defaults
    self.created_at ||= Time.now # set before save, to use value in callbacks
    self.taken_at ||= created_at
  end

  def set_bmi_values
    self.bmi ||= bmi_values[:bmi]
    self.bmi_level ||= bmi_values[:bmi_level]
  end

  def bmi_values
    @bmi_values ||= calculate_bmi_values
  end

  def calculate_bmi_values
    if most_recent_height_taken_at_weight && user.birth_date && user.gender
      CalculateBmiService.new(height: height, weight: self, birth_date: user.birth_date, gender: user.gender).call
    else
      {}
    end
  end

  def most_recent_height_taken_at_weight
    @height ||= user.heights.most_recent(taken_at)
  end
end

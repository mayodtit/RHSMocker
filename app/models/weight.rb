#Amount is in Kilograms
class Weight < ActiveRecord::Base
  belongs_to :user
  belongs_to :creator, class_name: 'Member'

  attr_accessible :user, :user_id, :amount, :bmi, :taken_at, :healthkit_uuid,
                  :healthkit_source, :creator_id, :creator

  validates :user, :amount, :taken_at, presence: true

  before_validation :set_defaults, on: :create
  before_save :set_bmi_values

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

  def set_bmi_values!
    self.bmi = nil
    self.bmi_level = nil
    @bmi_values = nil
    set_bmi_values
  end

  def bmi_values
    @bmi_values ||= calculate_bmi_values
  end

  def calculate_bmi_values
    if height = user.heights.most_recent(taken_at)
      CalculateBmiService.new(height: height, weight: self, birth_date: user.birth_date, gender: user.gender).call
    else
      {}
    end
  end
end

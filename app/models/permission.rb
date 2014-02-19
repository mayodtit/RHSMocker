class Permission < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject, class_name: 'Association'

  attr_accessible :user, :user_id, :subject, :subject_id, :name, :level

  symbolize :name, in: %i(basic_info medical_info care_team)
  symbolize :level, in: %i(none view edit)

  validates :user, :subject, :name, :level, presence: true
  validates :name, uniqueness: {scope: :subject_id}
  validate :basic_info_is_view_or_edit

  before_validation :set_user, on: :create

  private

  def basic_info_is_view_or_edit
    if (name == :basic_info) && (level == :none)
      errors.add(:level, 'must be at least view for basic_info')
    end
  end

  def set_user
    self.user ||= subject.associate
  end
end

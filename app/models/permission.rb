class Permission < ActiveRecord::Base
  belongs_to :subject, class_name: 'Association', inverse_of: :permission

  attr_accessible :subject, :subject_id, :basic_info, :medical_info, :care_team

  BASIC_INFO_LEVELS = %i(view edit)
  symbolize :basic_info, in: BASIC_INFO_LEVELS
  MEDICAL_INFO_LEVELS = %i(none view edit)
  symbolize :medical_info, in: MEDICAL_INFO_LEVELS
  CARE_TEAM_LEVELS = %i(none view edit)
  symbolize :care_team, in: CARE_TEAM_LEVELS

  validates :subject, presence: true
  validates :subject_id, uniqueness: true

  def self.default_levels
    {
      basic_info: :view,
      medical_info: :none,
      care_team: :none
    }
  end

  def self.max_levels
    {
      basic_info: :edit,
      medical_info: :edit,
      care_team: :edit
    }
  end

  def current_levels
    {
      basic_info: basic_info,
      medical_info: medical_info,
      care_team: care_team
    }
  end

  def copy_levels!(permission)
    update_attributes!(basic_info: permission.basic_info,
                       medical_info: permission.medical_info,
                       care_team: permission.care_team)
  end
end

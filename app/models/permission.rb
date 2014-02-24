class Permission < ActiveRecord::Base
  belongs_to :subject, class_name: 'Association'

  attr_accessible :subject, :subject_id, :basic_info, :medical_info, :care_team

  BASIC_INFO_LEVELS = %i(view edit)
  symbolize :basic_info, in: BASIC_INFO_LEVELS
  MEDICAL_INFO_LEVELS = %i(none view edit)
  symbolize :medical_info, in: MEDICAL_INFO_LEVELS
  CARE_TEAM_LEVELS = %i(none view edit)
  symbolize :care_team, in: CARE_TEAM_LEVELS

  validates :subject, presence: true
  validates :subject_id, uniqueness: true
end

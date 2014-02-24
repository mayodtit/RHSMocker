class Permission < ActiveRecord::Base
  belongs_to :subject, class_name: 'Association'

  attr_accessible :subject, :subject_id, :basic_info, :medical_info, :care_team

  symbolize :basic_info, in: %i(view edit)
  symbolize :medical_info, in: %i(none view edit)
  symbolize :care_team, in: %i(none view edit)

  validates :subject, presence: true
  validates :subject_id, uniqueness: true
end

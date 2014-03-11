class PermissionSerializer < ActiveModel::Serializer
  self.root = false

  attributes :subject_id, :basic_info, :medical_info, :care_team,
             :levels, :display_names, :created_at, :updated_at

  def levels
    {
      basic_info: Permission::BASIC_INFO_LEVELS,
      medical_info: Permission::MEDICAL_INFO_LEVELS,
      care_team: Permission::CARE_TEAM_LEVELS
    }
  end

  def display_names
    {
      basic_info: 'Personal Information',
      medical_info: 'Medical Information',
      care_team: 'Care Team'
    }
  end
end

class PermissionSerializer < ActiveModel::Serializer
  self.root = false

  attributes :subject_id, :basic_info, :medical_info, :care_team,
             :basic_info_levels, :medical_info_levels, :care_team_levels,
             :created_at, :updated_at

  def basic_info_levels
    Permission::BASIC_INFO_LEVELS
  end

  def medical_info_levels
    Permission::MEDICAL_INFO_LEVELS
  end

  def care_team_levels
    Permission::CARE_TEAM_LEVELS
  end
end

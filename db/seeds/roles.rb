%w(nurse admin super_admin pha pha_lead pha_bot hcc specialist service_admin engineer).each do |role|
  Role.find_or_create_by_name!(name: role)
end

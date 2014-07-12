%w(nurse admin pha pha_lead).each do |role|
  Role.find_or_create_by_name!(name: role)
end

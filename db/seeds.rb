%w(agreements
   allergies
   association_types
   conditions
   contents
   diets
   ethnic_groups
   messages
   roles
   service_types
   treatments).each do |filename|
     load File.join(Rails.root, 'db', 'seeds', "#{filename}.rb")
   end

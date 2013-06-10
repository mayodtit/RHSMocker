class Associate < User
  def as_json options=nil
    super.merge({
      :user_diseases=>user_diseases,
      :allergies=>allergies,
      :weights=>user_weights,
      :blood_pressures=>blood_pressures
      })
  end

  def update_attributes params
    params.slice(*Associate.attr_accessible[:default].map(&:to_sym)).each do |attr, val|
      send :"#{attr}=", val
    end
    save :validate=>false
  end
end

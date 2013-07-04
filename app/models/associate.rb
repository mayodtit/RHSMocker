class Associate < User
  validates :city, :state, :presence => true, :if => lambda{|a| a.inverse_associations.hcp.any?}

  def as_json options=nil
    super.merge({
      :user_diseases=>user_diseases,
      :allergies=>allergies,
      :weights=>weights,
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

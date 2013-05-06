class Associate < User
  def as_json options=nil
    {
      :id=>id,
      :first_name=>first_name,
      :last_name=>last_name,
      :birth_date=>birth_date,
      :phone=>phone,
      :image_url=>image_url,
      :gender=>gender,
      :height=>height,
      :user_diseases=>user_diseases,
      :allergies=>allergies
    }
  end

  def update_attributes params
    params.slice(*Associate.attr_accessible[:default].map(&:to_sym)).each do |attr, val|
      send :"#{attr}=", val
    end
    save :validate=>false
  end
end

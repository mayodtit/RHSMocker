class Disease < ActiveRecord::Base
  attr_accessible :name, :snomed_name, :snomed_code
  has_many :user_diseases
  has_many :users, :through=> :user_diseases

  searchable do
    text :name
    text :snomed_name
  end

  def as_json options=nil
    {
      id:id,
      name:name,
      snomed_name:snomed_name,
      snomed_code:snomed_code
    }
  end
end

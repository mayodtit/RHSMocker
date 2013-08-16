class Disease < ActiveRecord::Base
  include SoftDeleteModule

  attr_accessible :name, :snomed_name, :snomed_code
  has_many :user_diseases
  has_many :users, :through=> :user_diseases

  searchable do
    text :name
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

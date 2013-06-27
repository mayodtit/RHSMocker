class Treatment < ActiveRecord::Base
  attr_accessible :name, :type, :snomed_name, :snomed_code
  has_many :user_disease_treatments
  has_many :users, :through=> :user_disease_treatments

  has_many :treatment_side_effects
  has_many :side_effects, :through => :treatment_side_effects

  validates :type, :presence => true

  searchable do
    text :name
    text :snomed_name
    string :type do
      type_name
    end
  end

  def as_json options=nil
    {
      :id=>id,
      :type=>type_name,
      :name=>name,
      :snomed_name=>snomed_name,
      :snomed_code=>snomed_code
    }
  end

  def type_name
    self.class.name.demodulize.underscore.downcase
  end

  def self.type_class(type_name)
    "Treatment::#{type_name.camelize}".constantize
  end
end

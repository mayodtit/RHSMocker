class Treatment < ActiveRecord::Base
  include SoftDeleteModule
  include SolrExtensionModule

  attr_accessible :name, :type, :snomed_name, :snomed_code
  has_many :user_treatments
  has_many :users, :through=> :user_treatments

  has_many :treatment_side_effects
  has_many :side_effects, :through => :treatment_side_effects

  validates :type, :presence => true

  searchable :auto_index => false do
    text :name
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

class Condition < ActiveRecord::Base
  include SoftDeleteModule
  include SolrExtensionModule

  has_many :user_conditions
  has_many :users, :through => :user_conditions
  has_one :content

  attr_accessible :name, :snomed_name, :snomed_code, :concept_id, :description_id

  searchable do
    text :name
  end
end

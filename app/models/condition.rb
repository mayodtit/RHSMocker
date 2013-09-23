class Condition < ActiveRecord::Base
  include SoftDeleteModule
  include SolrExtensionModule

  has_many :user_conditions
  has_many :users, :through => :user_conditions

  attr_accessible :name, :snomed_name, :snomed_code

  searchable do
    text :name
  end
end

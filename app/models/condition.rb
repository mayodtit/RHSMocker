class Condition < ActiveRecord::Base
  include SoftDeleteModule
  include SolrExtensionModule

  has_many :user_conditions
  has_many :users, :through => :user_conditions
  has_one :content

  attr_accessible :name, :snomed_name, :snomed_code, :concept_id, :description_id

  after_commit :reindex

  searchable :auto_index => false do
    text :name
  end

  def reindex
    Condition.reindex
    Sunspot.commit
  end
end

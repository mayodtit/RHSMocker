class Allergy < ActiveRecord::Base
  include SoftDeleteModule
  include SolrExtensionModule

  has_many :user_allergies
  has_many :users, :through => :user_allergies

  attr_accessible :name, :snomed_name, :snomed_code, :food_allergen,
                  :environment_allergen, :medication_allergen

  after_commit :reindex

  searchable :auto_index => false do
    text :name
  end

  def self.none
    find_by_snomed_code('160244002')
  end

  def reindex
    Allergy.reindex
    Sunspot.commit
  end
end

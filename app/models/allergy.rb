class Allergy < ActiveRecord::Base
  include SoftDeleteModule
  include SolrExtensionModule

  has_many :user_allergies
  has_many :users, :through => :user_allergies
  belongs_to :master_synonym, class_name: 'Allergy',
                              inverse_of: :synonyms
  has_many :synonyms, class_name: 'Allergy',
                      foreign_key: :master_synonym_id,
                      inverse_of: :master_synonym

  attr_accessible :name, :snomed_name, :snomed_code, :food_allergen,
                  :environment_allergen, :medication_allergen, :concept_id, :description_id,
                  :master_synonym, :master_synonym_id

  validates :master_synonym, presence: true, if: ->(a){a.master_synonym_id}

  searchable :auto_index => false do
    text :name
  end

  def self.none
    find_by_snomed_code('160244002')
  end
end

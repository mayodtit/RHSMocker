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

  def self.identify_synonyms!
    names_with_duplicates.each do |name|
      master = find_by_name_and_master_synonym_id(name, nil)
      where(name: name, master_synonym_id: nil).where('id != ?', master.id).each do |instance|
        instance.user_allergies.each do |ua|
          unless ua.update_attributes(allergy: master)
            ua.destroy
          end
        end
        instance.update_attributes!(master_synonym: master, skip_reindex: true)
      end
    end
    reindex
    Sunspot.commit
  end

  def self.names_with_duplicates
    group(:name).count.reject{|k, v| v < 2}.keys
  end
end

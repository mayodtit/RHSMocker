class Allergy < ActiveRecord::Base
  include SoftDeleteModule
  include SolrExtensionModule

  has_many :user_allergies
  has_many :users, :through => :user_allergies

  attr_accessible :name, :snomed_name, :snomed_code, :food_allergen,
                  :environment_allergen, :medication_allergen, :concept_id, :description_id

  searchable :auto_index => false do
    text :name
  end

  def self.none
    find_by_snomed_code('160244002')
  end

  def self.deduplicate_names!
    names_with_duplicates.each do |name|
      instances = where(name: name)
      master = instances.first
      instances.drop(1).each_with_index do |instance|
        instance.user_allergies.each do |ua|
          ua.update_attributes!(allergy: master)
        end
        instance.destroy!
      end
    end
  end

  def self.names_with_duplicates
    group(:name).count.reject{|k, v| v < 2}.keys
  end
end

class TreatmentSideEffect < ActiveRecord::Base
  belongs_to :treatment
  belongs_to :side_effect

  attr_accessible :treatment, :side_effect
  attr_accessible :treatment_id, :side_effect_id

  validates :treatment, :presence => true
  validates :side_effect, :presence => true

  delegate :name, :description, :to => :side_effect

  searchable do
    text :name do
      name
    end
    integer :treatment_id
  end

  def as_json
    {
      id: id,
      name: name,
      description: description
    }
  end
end

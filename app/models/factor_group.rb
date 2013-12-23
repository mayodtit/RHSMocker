class FactorGroup < ActiveRecord::Base
  belongs_to :symptom
  has_many :factors

  attr_accessible :symptom, :symptom_id, :name

  validates :symptom, :name, presence: true
  validates :name, uniqueness: {scope: :symptom_id}
end

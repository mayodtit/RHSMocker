class ContentsSymptomsFactor < ActiveRecord::Base
  belongs_to :content
  belongs_to :symptoms_factor

  attr_accessible :content, :content_id, :symptoms_factor, :symptoms_factor_id

  validates :content, :symptoms_factor, presence: true
  validates :content_id, uniqueness: {scope: :symptoms_factor_id}
end

class ContentsSymptomsFactor < ActiveRecord::Base
  belongs_to :content
  belongs_to :symptoms_factor

  attr_accessible :symptoms_factor_id, :content_id

end
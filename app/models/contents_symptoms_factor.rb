class ContentsSymptomsFactor < ActiveRecord::Base
  belongs_to :content
  belongs_to :symptoms_factor
end

class ContentsMayoVocabulary < ActiveRecord::Base
  attr_accessible :mayo_vocabulary_id

  belongs_to :mayo_vocabulary
  belongs_to :content

end
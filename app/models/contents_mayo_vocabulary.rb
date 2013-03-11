
class ContentsMayoVocabulary < ActiveRecord::Base
  belongs_to :mayo_vocabulary
  belongs_to :content

end
class MayoVocabulariesMessage < ActiveRecord::Base
  attr_accessible :mayo_vocabulary_id, :message_id

  belongs_to :mayo_vocabulary
  belongs_to :message

end
class MessageMayoVocabulary < ActiveRecord::Base
  belongs_to :message
  belongs_to :mayo_vocabulary

  attr_accessible :message, :message_id, :mayo_vocabulary, :mayo_vocabulary_id

  validates :message, :mayo_vocabulary, presence: true
  validates :mayo_vocabulary_id, :uniqueness => {:scope => :message_id}
end

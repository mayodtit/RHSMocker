class ContentMayoVocabulary < ActiveRecord::Base
  belongs_to :content
  belongs_to :mayo_vocabulary

  attr_accessible :content, :content_id, :mayo_vocabulary, :mayo_vocabulary_id

  validates :content, :mayo_vocabulary, presence: true
  validates :mayo_vocabulary_id, :uniqueness => {:scope => :content_id}
end

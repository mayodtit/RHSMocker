class MayoVocabulary < ActiveRecord::Base
  attr_accessible :mcvid, :title
  has_many :contents_mayo_vocabularies
  has_many :contents, :through => :contents_mayo_vocabularies
  has_and_belongs_to_many :messages
end

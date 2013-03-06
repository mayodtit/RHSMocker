class MayoVocabulary < ActiveRecord::Base
  attr_accessible :mcvid, :title
  has_and_belongs_to_many :contents
  has_and_belongs_to_many :messages
end

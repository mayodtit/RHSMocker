class MayoVocabulary < ActiveRecord::Base
  attr_accessible :mcvid, :title
  has_many :contents_mayo_vocabularies
  has_many :contents, :through => :contents_mayo_vocabularies

  has_many :mayo_vocabularies_messages
  has_many :messages, :through => :mayo_vocabularies_messages
  
  def as_json options=nil
    {
      :title=>title,
      :mcvid=>mcvid
    }
  end
end

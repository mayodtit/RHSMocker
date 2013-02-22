class MayoVocabulary < ActiveRecord::Base
  	attr_accessible :mcvid, :title

	has_many :content_vocabularies
	has_many :contents, :through => :content_vocabularies

end

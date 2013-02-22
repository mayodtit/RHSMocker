class ContentVocabulary < ActiveRecord::Base
    attr_accessible :content, :mayo_vocabulary

 	belongs_to :content
  	belongs_to :mayo_vocabulary

end

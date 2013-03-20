class Attachment < ActiveRecord::Base
  attr_accessible :url
  belongs_to :message


  def as_json options=nil
    {
      :url=>url
    }
  end
end

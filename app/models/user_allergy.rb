class UserAllergy < ActiveRecord::Base
  belongs_to :user
  belongs_to :allergy
  attr_accessible :user, :allergy #:title, :body


  def as_json options=nil
    {
      :id=>id,
      :allergy=>allergy
    }
  end
  
end

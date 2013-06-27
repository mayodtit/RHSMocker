class UserAllergy < ActiveRecord::Base
  belongs_to :user
  belongs_to :allergy

  attr_accessible :user, :allergy
  attr_accessible :user_id, :allergy_id

  validates :user, :allergy, :presence => true
  validates :allergy_id, :uniqueness => {:scope => :user_id}

  def as_json(options=nil)
    {
      :id=>id,
      :allergy=>allergy
    }
  end
end

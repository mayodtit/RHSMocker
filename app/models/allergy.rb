class Allergy < ActiveRecord::Base
  attr_accessible :name
  has_many :user_allergies
  has_many :user, :through=>:user_allergies

  searchable do
    text :name
  end

  def as_json options=nil
    {
      :id=>id,
      :name=>name
    }
  end
end

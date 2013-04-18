class Treatment < ActiveRecord::Base
  attr_accessible :name
  has_many :user_disease_treatments
  has_many :users, :through=> :user_disease_treatments

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

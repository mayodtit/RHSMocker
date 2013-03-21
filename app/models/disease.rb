class Disease < ActiveRecord::Base
  attr_accessible :name
  has_many :user_diseases
  has_many :users, :through=> :user_diseases

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

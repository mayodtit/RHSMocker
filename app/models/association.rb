class Association < ActiveRecord::Base
  belongs_to :user
  belongs_to :associate
  attr_accessible :relation, :relation_type, :user, :associate

  validates :relation_type, :inclusion =>{
    :in=> %w(family hcp),
    :message=>"%{value} is not valid. Only 'family' or 'hcp' accepted'.",
    :allow_nil=>false }

  validates :relation, :inclusion=> {
    :in=> %w(brother sister mother father grandfather grandmother cousin son daughter uncle aunt doctor nurse),
    :message=> "%{value} is not valid.",
    :allow_nil=>true
  }

  def as_json options=nil
    {
      :id=>id,
      :relation=>relation,
      :relation_type=>relation_type,
      :associate=>associate
    }
  end
end

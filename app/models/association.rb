class Association < ActiveRecord::Base
  belongs_to :user
  belongs_to :associate
  belongs_to :association_type
  attr_accessible :association_type_id, :user, :associate

  validate :not_its_own_associate

  def not_its_own_associate
    errors.add(:user, "cannot be associated to itself") if self.user.id==self.associate.id
  end 

  def as_json options=nil
    {
      id:id,
      association_type:association_type,
      associate:associate
    }
  end
end

class Association < ActiveRecord::Base
  belongs_to :user
  belongs_to :associate, :class_name => 'User'
  belongs_to :association_type
  accepts_nested_attributes_for :associate

  attr_accessible :user, :associate, :association_type, :associate_attributes
  attr_accessible :user_id, :associate_id, :association_type_id

  validates :user, :associate, :association_type, presence: true
  validate :user_is_not_associate

  def self.hcp
    joins(:association_type).where(:association_types => {:relationship_type => 'hcp'})
  end

  def as_json options=nil
    super.merge!(associate: associate, association_type: association_type)
  end

  private

  def user_is_not_associate
    errors.add(:user, "cannot be associated to itself") if user == associate
  end
end

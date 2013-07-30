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

  def serializable_hash options=nil
    options ||= {}
    options.merge!(:include => [:associate, :association_type]) do |k, v1, v2|
      v1.is_a?(Array) ? v1 + v2 : [v1] + v2
    end

    # add invitation status to the associate before return
    super(options).merge({:associate => {:invited => invited?}}){|k,v1,v2| v1.merge!(v2)}
  end

  private

  def user_is_not_associate
    errors.add(:user, "cannot be associated to itself") if user == associate
  end

  def invited?
    associate.member ? Invitation.exists_for_pair?(user_id, associate.member.id) : false
  end
end

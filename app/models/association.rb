class Association < ActiveRecord::Base
  belongs_to :user
  belongs_to :associate, :class_name => 'User'
  belongs_to :association_type
  accepts_nested_attributes_for :associate

  attr_accessible :user, :user_id, :associate, :associate_id, :association_type,
                  :association_type_id, :associate_attributes

  validates :user, :associate, presence: true
  validate :user_is_not_associate
  validates :associate_id, uniqueness: {scope: [:user_id, :association_type_id]}

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

class UserAllergy < ActiveRecord::Base
  belongs_to :user
  belongs_to :allergy

  attr_accessor :actor_id

  attr_accessible :user, :user_id, :allergy, :allergy_id, :actor_id

  validates :user, :allergy, :presence => true
  validates :allergy_id, :uniqueness => {:scope => :user_id}

  def as_json(options=nil)
    {
      :id=>id,
      :allergy=>allergy
    }
  end

  after_destroy :track_destroy
  after_create :track_create

  def track_create
    self.actor_id ||= Member.robot.id
    UserChange.create! user: user, actor_id: actor_id, action: 'add', data: {allergies: [allergy.name]}
  end

  def track_destroy
    self.actor_id ||= Member.robot.id
    UserChange.create! user: user, actor_id: actor_id, action: 'destroy', data: {allergies: [allergy.name]}
  end
end

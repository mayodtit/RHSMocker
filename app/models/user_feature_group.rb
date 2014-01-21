class UserFeatureGroup < ActiveRecord::Base
  belongs_to :user
  belongs_to :feature_group

  attr_accessible :user, :feature_group

  validates :user, :feature_group, presence: true
  validates :feature_group_id, :uniqueness => {:scope => :user_id}

  after_create :set_premium, if: lambda{|ufg| ufg.feature_group.premium?}

  private

  def set_premium
    user.cards.create(resource: Content.premium) if Content.premium
    true
  end
end

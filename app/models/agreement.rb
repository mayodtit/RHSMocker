class Agreement < ActiveRecord::Base
  has_many :user_agreements
  has_many :users, through: :user_agreements

  attr_accessible :text, :active

  validates :text, presence: true
  validates :active, inclusion: {in: [true, false]}
  validates :active, uniqueness: true, if: :active?

  def self.active
    where(active: true).first
  end

  def activate!
    return true if active?
    transaction do
      self.class.update_all(active: false)
      update_attributes!(active: true)
    end
  end
end

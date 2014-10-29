class NuxStory < ActiveRecord::Base
  attr_accessible :html, :action_button_text, :show_nav_signup, :unique_id,
                  :ordinal

  validates :html, :action_button_text, presence: true
  validates :show_nav_signup, inclusion: {in: [true, false]}
  validates :unique_id, presence: true, uniqueness: true
  validates :ordinal, uniqueness: true, allow_nil: true

  def self.enabled
    where('ordinal IS NOT NULL').order(:ordinal)
  end

  def self.trial
    find_by_unique_id('TRIAL')
  end

  def self.sign_up_success
    find_by_unique_id('SIGN_UP_SUCCESS')
  end
end

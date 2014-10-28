class NuxStory < ActiveRecord::Base
  attr_accessible :html, :action_button_text, :show_nav_signup, :unique_id

  validates :html, :action_button_text, presence: true
  validates :show_nav_signup, inclusion: {in: [true, false]}
  validates :unique_id, presence: true, uniqueness: true
end

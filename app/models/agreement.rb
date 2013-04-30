class Agreement < ActiveRecord::Base
  belongs_to :agreement_page
  belongs_to :user
  attr_accessible :ip_address, :user_agent, :user, :agreement_page

  scope :user_agreement, lambda { joins(:agreement_page).where("agreement_pages.page_type = ?", "user_agreement") }
  scope :privacy_policy, lambda { joins(:agreement_page).where("agreement_pages.page_type = ?", "privacy_policy") }

  def as_json options=nil
  	{
  		id:id,
  		created_at:created_at,
  		agreement_page:agreement_page
  	}
  end
end

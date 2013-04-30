class AgreementPage < ActiveRecord::Base
  attr_accessible :content, :page_type
  scope :user_agreement, where(:page_type=>"user_agreement")
  scope :privacy_policy, where(:page_type=>"privacy_policy")

  def self.page_types 
  	["user_agreement", "privacy_policy"]
  end

  def latest? 
  	id == AgreementPage.send(page_type).last.id
  end

  def as_json options=nil
  	{
  		id:id,
  		content:content,
  		page_type:page_type,
  		latest:latest?
  	}
  end
end

class PhaProfileSerializer < ActiveModel::Serializer
  self.root = false

  has_one :user
  attributes :id, :user_id, :bio_image_url, :bio, :weekly_capacity,
             :capacity_weight, :full_page_bio_image_url,
             :mayo_pilot_capacity_weight

  def bio
    if object.bio
      "#{object.bio}\n\n#{offline_quote}"
    else
      offline_quote
    end
  end

  private

  def offline_quote
    "Our Personal Health Assistant team is dedicated to caring for you and your family’s health needs. If you need help right away when #{object.user.try(:first_name)} is offline, another member of the team may ask if he or she can assist you."
  end
end

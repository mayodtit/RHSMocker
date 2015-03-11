class ProviderSearch < ActiveRecord::Base
  attr_accessible :id, :provider_search_preferences_id, :state, :user_id

  belongs_to :user
  has_one :provider_search_preferences

  ## TODO Assign the preferences
  ##      Send request
  ##      Turn the responses into ProviderSearchResults
  ##      Create/merge ProviderSearchResults into ProviderProfiles
  ##      Ranking
  ##      Comments
end

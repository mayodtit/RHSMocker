class ProviderSearchResult < ActiveRecord::Base
  attr_accessible :id, :provider_profile_id, :provider_search_id, :state

  belongs_to :provider_search
  belongs_to :provider_profile

  ## TODO Default value for state? Add to migration
end

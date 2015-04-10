class ProviderSearchResult < ActiveRecord::Base
  attr_accessible :id, :provider_profile_id, :provider_search_id, :state

  acts_as_commentable

  belongs_to :provider_search
  belongs_to :provider_profile

  ## TODO Default value for state? Add to migration
end

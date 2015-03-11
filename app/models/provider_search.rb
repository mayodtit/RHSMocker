class ProviderSearch < ActiveRecord::Base
  attr_accessible :id, :provider_search_preferences_id, :state, :user_id, :preferences

  belongs_to :user

  ## This is belongs_to when it is conceptually a has_one. Preferences are dependent objects
  ##   but can belong to multiple other classes (ProviderSearch, User, etc)
  ## Possibly a polymorphic?
  belongs_to :preferences, class_name: ProviderSearchPreferences, foreign_key: :provider_search_preferences_id
  validates_presence_of :preferences

  ## TODO Remove when done testing
  def self.default_preferences
    ProviderSearchPreferences.new(lat: "37.773", lon: "-122.413", distance: 10, gender: "female")
  end

  def perform_search
    raise 'Search preferences missing' unless (preferences && preferences.valid?)

    results = DataSources::BetterDoctor.search(preferences.to_h)

    if results.is_a?(Hash) && results.has_key?(:error)
      raise results[:error]
    end

    results.map do |api_result|
      profile = ProviderProfile.find_by_npi_number(api_result[:npi_number]) || ProviderProfile.new
      profile.update_attributes(api_result)
      profile
    end

    ## TODO Create ProviderSearchResults based on those profiles
  end
end

class ProviderSearch < ActiveRecord::Base
  attr_accessible :preferences, :provider_search_preferences_id, :state, :user, :user_id

  acts_as_commentable

  belongs_to :user

  ## Generic wrappers in case we expand beyond BetterDoctor
  def self.insurance_values
    @insurance_values ||= DataSources::BetterDoctor.insurances.map{|insurance| insurance[:uid] }
  end

  def self.specialty_values
    @specialty_values ||= DataSources::BetterDoctor.specialties.map{|specialty| specialty[:uid] }
  end

  ## TODO Remove when done testing
  def self.default_preferences
    ProviderSearchPreferences.new(lat: "37.773", lon: "-122.413", distance: 10, gender: "female")
  end

  belongs_to :preferences, class_name: ProviderSearchPreferences, foreign_key: :provider_search_preferences_id
  validates_presence_of :preferences

  has_many :provider_search_results
  has_many :provider_profiles, through: :provider_search_results

  def perform_search
    raise 'Search preferences missing' unless (preferences && preferences.valid?)

    results = DataSources::BetterDoctor.search(preferences.to_h)

    if results.is_a?(Hash) && results.has_key?(:error)
      raise results[:error]
    end

    results.map do |api_result|
      profile = ProviderProfile.where(npi_number: api_result[:npi_number]).first_or_create.tap do |pr|
        pr.update_attributes(api_result)
      end
    end.map do |profile|
      ProviderSearchResult.where(provider_search_id: self.id, provider_profile_id: profile.id).first_or_create
    end

    provider_profiles
  end
end

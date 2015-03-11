class ProviderProfile < ActiveRecord::Base
  attr_accessible :first_name, :gender, :id, :image_url, :last_name, :npi_number, :ratings

  serialize :ratings, Array
  validates :npi_number, length: {is: 10}, uniqueness: true, if: :npi_number

  has_many :provider_search_results
  has_many :provider_searches, through: :provider_search_results
end

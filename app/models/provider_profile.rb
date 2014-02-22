class ProviderProfile < ActiveRecord::Base
  attr_accessible :npi_number, :taxonomy_code

  validates :npi_number, length: {is: 10}, uniqueness: true, allow_nil: true
  validates :taxonomy_code, length: {is: 10}, allow_nil: true
end

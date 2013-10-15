class Metadata < ActiveRecord::Base
  attr_accessible :key, :value

  validates :key, :value, presence: true
  validates :key, uniqueness: true

  def self.to_hash
    all.inject({}){|hash, metadata| hash[metadata.key] = metadata.value; hash}
  end
end

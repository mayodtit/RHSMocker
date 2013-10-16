class Metadata < ActiveRecord::Base
  attr_accessible :key, :value

  validates :key, :value, presence: true
  validates :key, uniqueness: true

  def self.to_hash
    all.inject({}){|hash, metadata| hash[metadata.key] = metadata.value; hash}
  end

  def self.to_hash_for(user)
    user.feature_groups.inject(to_hash) do |hash, fg|
      hash.merge!(fg.metadata_override) if fg.metadata_override
    end
  end
end

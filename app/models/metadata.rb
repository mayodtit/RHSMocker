class Metadata < ActiveRecord::Base
  attr_accessible :mkey, :mvalue

  validates :mkey, :mvalue, presence: true
  validates :mkey, uniqueness: true

  def self.to_hash
    all.inject({}){|hash, metadata| hash[metadata.mkey] = metadata.mvalue; hash}
  end

  def self.to_hash_for(user)
    user.feature_groups.inject(to_hash) do |hash, fg|
      hash.merge!(fg.metadata_override) if fg.metadata_override
    end
  end

  def self.use_invite_flow?
    Metadata.find_by_mkey('use_invite_flow').try(:mvalue) == 'true'
  end

  def self.nurse_phone_number
    Metadata.find_by_mkey('nurse_phone_number').try(:mvalue) || NURSE_PHONE_NUMBER
  end

  def self.pha_phone_number
    Metadata.find_by_mkey('pha_phone_number').try(:mvalue) || PHA_PHONE_NUMBER
  end

  def self.value_for_key(key)
    find_by_mkey(key).try(:mvalue)
  end

  def self.allow_tos_checked?
    Metadata.find_by_mkey('allow_tos_checked').try(:mvalue) == 'true'
  end
end

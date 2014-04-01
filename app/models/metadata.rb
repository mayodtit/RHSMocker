class Metadata < ActiveRecord::Base
  attr_accessible :mkey, :mvalue

  validates :mkey, :mvalue, presence: true
  validates :mkey, uniqueness: true

  def self.to_hash
    all.inject({}){|hash, metadata| hash[metadata.mkey] = metadata.mvalue; hash}
  end

  def self.to_hash_for(user)
    to_hash.tap do |hash|
      user.feature_groups.each do |fg|
        hash.merge!(fg.metadata_override) if fg.metadata_override
      end
      hash[:needs_agreement] = true if user.needs_agreement?
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

  def self.new_card_design?
    Metadata.find_by_mkey('new_card_design').try(:mvalue) == 'true'
  end

  def self.force_phas_off_call?
    !Rails.env.production? && Metadata.find_by_mkey('force_phas_off_call').try(:mvalue) == 'true'
  end
end

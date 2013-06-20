class Offering < ActiveRecord::Base
  attr_accessible :name

  def self.hash_ids_to_objects(hash)
    Offering.where(:id => hash.keys).inject({}){|h, offering| h[offering] = hash[offering.id]; h}
  end
end

class Offering < ActiveRecord::Base
  attr_accessible :name
  attr_accessor :credits

  def as_json
    json = {id: id, name: name}
    json[:credits] = credits if credits
    json
  end

  def self.with_credits(hash)
    Offering.where(:id => hash.keys).each do |offering|
      offering.credits = hash[offering.id]
    end
  end
end

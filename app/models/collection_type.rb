class CollectionType < ActiveRecord::Base
  attr_accessible :name

  def self.self_reported
    find_by_name('self-reported') || create(name: 'self-reported')
  end
end

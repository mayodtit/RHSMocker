class Agreement < ActiveRecord::Base
  self.inheritance_column = nil # allow use non-STI :type column name

  has_many :user_agreements
  has_many :users, :through => :user_agreements

  attr_accessible :text, :type, :active

  validates :text, :type, presence: true
  validates :active, :inclusion => {:in => [true, false]}
  validates :active, :uniqueness => {:scope => :type}, :if => :active?

  symbolize :type, :in => [:terms_of_service, :privacy_policy], :scopes => :shallow, :methods => true

  def self.active
    where(:active => true)
  end

  def self.current_for(type)
    where(:type => type).active.first
  end

  def activate!
    return true if active?
    transaction do
      self.class.update_all(:active => false)
      update_attributes!(:active => true)
    end
  end
end

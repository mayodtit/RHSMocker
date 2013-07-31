class MayoVocabulary < ActiveRecord::Base
  has_many :contents_mayo_vocabularies
  has_many :contents, :through => :contents_mayo_vocabularies
  has_many :mayo_vocabularies_messages
  has_many :messages, :through => :mayo_vocabularies_messages

  attr_accessible :mcvid, :title

  validates :mcvid, :title, presence: true
  validates :mcvid, uniqueness: true

  def self.find_by_title(title)
    where("lower(title) = ?", title.downcase).first
  end

  def serializable_hash options=nil
    options ||= {}
    options.merge!(:only => [:mcvid, :title]) do |k, v1, v2|
      v1.is_a?(Array) ? v1 + v2 : [v1] + v2
    end
    super(options)
  end
end

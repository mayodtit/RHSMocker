class MayoVocabulary < ActiveRecord::Base
  has_many :content_mayo_vocabularies
  has_many :contents, :through => :content_mayo_vocabularies
  has_many :message_mayo_vocabularies
  has_many :messages, :through => :message_mayo_vocabularies

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

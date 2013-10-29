class MayoVocabulary < ActiveRecord::Base
  CSV_COLUMNS = %w(id mcvid title content_title content_mayo_doc_id)

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

  def serializable_hash(options=nil)
    options ||= {:only => [:mcvid, :title]}
    super(options)
  end

  def self.for_age(age)
    case age
    when 0..2
      %w(1119 1120)
    when 3..5
      %w(1121)
    when 6..12
      %w(1122)
    when 13..18
      %w(1123)
    when 19..44
      %w(1125)
    when 45..64
      %w(1126)
    when 65..80
      %w(1127)
    when 80..200
      %w(1128)
    else
      []
    end
  end

  def self.for_gender(gender)
    if gender == 'F'
      %w(1131 3899 3900)
    elsif gender == 'M'
      %w(1130 3896 3897)
    else
      []
    end
  end

  def self.with_contents
    joins(:contents).select('mayo_vocabularies.*,
                             contents.title AS content_title,
                             contents.mayo_doc_id AS content_mayo_doc_id')
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << CSV_COLUMNS
      with_contents.find_each do |vocab|
        csv << vocab.attributes.values_at(*CSV_COLUMNS)
      end
    end
  end
end

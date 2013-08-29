class User < ActiveRecord::Base

  rolify

  has_many :associations, :dependent => :destroy
  has_many :associates, :through=>:associations
  has_many :inverse_associations, :class_name => 'Association', :foreign_key => 'associate_id'
  has_many :inverse_associates, :through => :inverse_associations, :source => :user

  has_many :weights
  has_many :blood_pressures
  has_many :user_allergies
  has_many :allergies, :through=>:user_allergies
  has_many :user_conditions
  has_many :conditions, :through=> :user_conditions
  has_many :user_treatments
  has_many :treatments, :through=> :user_treatments
  belongs_to :ethnic_group
  belongs_to :diet

  attr_accessible :first_name, :last_name, :image_url, :gender, :height, :birth_date, :email,
                  :phone, :blood_type, :diet_id, :ethnic_group_id, :npi_number, :deceased,
                  :date_of_death, :expertise, :city, :state

  validates :deceased, :inclusion => {:in => [true, false]}
  validates :npi_number, :length => {:is => 10}, :uniqueness => true, :if => :npi_number

  mount_uploader :image_url, AvatarUploader

  def full_name
    return "Not Set" if first_name.blank? || last_name.blank?
    "#{first_name} #{last_name}".strip
  end

  def age
    if birth_date.nil?
      birth_date
    else
      now = Time.now.utc.to_date
      now.year - self.birth_date.year - ((now.month > self.birth_date.month || (now.month == self.birth_date.month && now.day >= self.birth_date.day)) ? 0 : 1)
    end
  end

  BASE_OPTIONS = {:only => [:id, :first_name, :last_name, :birth_date, :blood_type,
                            :diet_id, :email, :ethnic_group_id, :gender, :height,
                            :image_url, :deceased, :date_of_death, :npi_number, :expertise],
                  :methods => [:blood_pressure, :weight]}

  def serializable_hash options=nil
    options ||= BASE_OPTIONS
    super(options)
  end

  def member
    return nil unless email
    Member.find_by_email(email)
  end

  def blood_pressure
    blood_pressures.most_recent
  end

  def weight
    weights.most_recent
  end
end

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
  has_many :user_diseases
  has_many :diseases, :through=> :user_diseases
  has_many :user_disease_treatments
  has_many :treatments, :through=> :user_disease_treatments
  belongs_to :ethnic_group
  belongs_to :diet

  attr_accessible :first_name, :last_name, :image_url, :gender, :height, :birth_date, :email,
                  :phone, :blood_type, :diet_id, :ethnic_group_id, :npi_number, :deceased,
                  :date_of_death, :expertise, :city, :state

  validates :deceased, :inclusion => {:in => [true, false]}
  validates :npi_number, :length => {:is => 10}, :uniqueness => true, :if => :npi_number

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

  def most_recent_blood_pressure
    BloodPressure.most_recent_for_user(self)
  end

  def most_recent_weight
    Weight.most_recent_for(self)
  end

  def as_json options=nil
    {
      id:id,
      first_name:first_name,
      last_name:last_name,
      birth_date:birth_date,
      blood_type:blood_type,
      diet_id:diet_id,
      email:email,
      ethnic_group_id:ethnic_group_id,
      gender:gender,
      height:height,
      image_url:image_url,
      deceased:deceased,
      date_of_death:date_of_death,
      npi_number:npi_number,
      expertise:expertise,
      blood_pressure: most_recent_blood_pressure,
      weight: most_recent_weight
    }
  end
end

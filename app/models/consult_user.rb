class ConsultUser < ActiveRecord::Base
  belongs_to :consult
  belongs_to :user

  attr_accessible :user, :user_id, :consult, :consult_id, :role, :read

  validates :consult, :user, presence: true
  validates :user_id, :uniqueness => {:scope => :consult_id}

  def self.patients
    where(:role => :patient)
  end
end

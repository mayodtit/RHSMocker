class Factor < ActiveRecord::Base
  belongs_to :factor_group
  has_many :factor_contents
  has_many :contents, through: :factor_contents

  attr_accessible :factor_group, :factor_group_id, :name, :gender

  validates :factor_group, :name, presence: true
  validates :gender, inclusion: {in: %w(M F)}, allow_nil: true
  validates :name, uniqueness: {scope: :factor_group_id}
end

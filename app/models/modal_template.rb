class ModalTemplate < ActiveRecord::Base
  has_many :tasks
  attr_accessible :title, :description, :accept, :reject
  validates :title, presence: true
end

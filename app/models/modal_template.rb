class ModalTemplate < ActiveRecord::Base
  has_many :task_templates

  attr_accessible :title, :description, :accept, :reject
  validates :title, :description, :accept, :reject, presence: true

  def create_copy!
    self.class.create!(attributes.except('id', 'created_at', 'updated_at'))
  end
end

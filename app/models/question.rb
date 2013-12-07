class Question < ActiveRecord::Base
  attr_accessible :title, :view

  symbolize :view, in: [:gender, :diet, :allergies]

  validates :title, :view, presence: true, uniqueness: true

  def self.new_member_questions
    where(:view => [:diet, :gender, :allergies])
  end
end

class Question < ActiveRecord::Base
  attr_accessible :title, :view

  validates :title, :view, presence: true, uniqueness: true

  def self.new_member_questions
    where(:view => [:diet, :gender])
  end

  def content_type
    'Question'
  end
end

class TaskCategory < ActiveRecord::Base
  has_many :tasks
  has_many :task_templates
  has_many :task_category_expertises
  has_many :expertises, through: :task_category_expertises

  attr_accessible :title, :description, :priority_weight

  validates :title, :description, :priority_weight, presence: true

  def has_expertise?(expertise)
    expertise_names.include?(expertise.to_s)
  end

  def add_expertise(expertise_name)
    return if has_expertise? expertise_name

    expertise = Expertise.where(name: expertise_name).first_or_create!
    expertises << expertise
    @expertise_names << expertise.name.to_s if @expertise_names
  end

  def expertise_names
    @expertise_names ||= expertises.pluck(:name)
  end
end

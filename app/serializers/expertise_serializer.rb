class ExpertiseSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :user_count, :category_count, :template_count

  delegate :users, :task_categories, :task_templates, to: :object

  private

  def category_count
    task_categories.try(:count)
  end

  def template_count
    task_templates.try(:count)
  end

  def user_count
    users.try(:count)
  end
end

class TaskCategorySerializer < ActiveModel::Serializer

  attributes :id, :title, :description, :priority_weight, :expertise_id

  has_one :expertise

end

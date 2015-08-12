class TaskCategorySerializer < ActiveModel::Serializer

  attributes :id, :title, :description, :priority_weight

end

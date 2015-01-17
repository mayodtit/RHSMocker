class ConditionSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :created_at, :updated_at, :snomed_name, :snomed_code,
             :content_id

  def content_id
    # (TS 2015-01-16) This results in n database queries, one for each related
    # content.  In production all of these values are null, so just return
    # null instead (but still keep the content_id in the return).
    #object.content.try(:id)

    nil
  end
end

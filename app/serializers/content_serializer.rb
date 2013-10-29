class ContentSerializer < ActiveModel::Serializer
  self.root = false

  # TODO - remove duplicate contents_type and contentID when the client no longer requires them
  attributes :id, :title, :content_type, :content_updated_at, :document_id,
             :created_at, :updated_at, :contents_type, :contentID, :content_type_display

  def contents_type
    content_type
  end

  def contentID
    id
  end
end

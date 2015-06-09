class FeatureFlagSerializer < ActiveModel::Serializer
  self.root = false

  attributes :title, :mvalue, :description

  def title
    object.mkey.try(:titleize)
  end
end

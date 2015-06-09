class FeatureFlagSerializer < ActiveModel::Serializer
  self.root = false

  attributes :title, :enabled, :description

  def title
    object.mkey.try(:titleize)
  end

  def enabled
    object.feature_enabled?
  end
end

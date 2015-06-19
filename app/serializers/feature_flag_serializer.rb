class FeatureFlagSerializer < ActiveModel::Serializer
  self.root = false
  delegate :mkey, :enabled?, to: :object

  attributes :id, :mkey, :title, :enabled, :description

  def title
    mkey.try(:titleize)
  end

  def enabled
    enabled?
  end
end

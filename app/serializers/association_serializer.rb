class AssociationSerializer < ViewSerializer
  self.root = false

  attributes :id, :user_id, :associate_id, :association_type_id, :created_at, :updated_at,
             :is_default_hcp
  has_one :associate
  has_one :association_type

  delegate :user, :associate, :creator, to: :object

  def is_default_hcp
    user.default_hcp_association_id == object.id
  end
end

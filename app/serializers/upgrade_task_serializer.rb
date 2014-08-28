class UpgradeTaskSerializer < TaskSerializer
  attributes :member_id

  def type
    'user-upgrade'
  end
end

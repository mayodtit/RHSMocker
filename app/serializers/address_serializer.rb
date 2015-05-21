class AddressSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :user_id, :address, :address2, :line1, :line2, :city, :state,
             :postal_code, :name, :type

  has_many :phone_numbers
end

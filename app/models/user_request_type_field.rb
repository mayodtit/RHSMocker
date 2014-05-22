class UserRequestTypeField < ActiveRecord::Base
  self.inheritance_column = nil

  belongs_to :user_request_type

  attr_accessible :user_request_type, :user_request_type_id, :name, :type,
                  :ordinal

  validates :user_request_type, :name, :type, :ordinal, presence: true
  validates :ordinal, uniqueness: {scope: :user_request_type_id}

  before_validation :set_ordinal, on: :create

  private

  def set_ordinal
    self.ordinal ||= max_ordinal + 1
  end

  def max_ordinal
    self.class.where(user_request_type_id: user_request_type.id)
              .order('ordinal DESC')
              .pluck(:ordinal)
              .first || 0
  end
end

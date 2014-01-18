class Consult < ActiveRecord::Base
  belongs_to :initiator, class_name: 'Member'
  belongs_to :subject, class_name: 'User'
  belongs_to :symptom
  has_many :messages, inverse_of: :consult
  has_many :phone_calls, through: :messages
  has_many :scheduled_phone_calls, through: :messages
  has_many :cards, as: :resource, dependent: :destroy

  attr_accessible :initiator, :initiator_id, :subject, :subject_id, :symptom,
                  :symptom_id, :state, :title, :description, :image,
                  :messages_attributes

  validates :initiator, :subject, :state, :title, presence: true
  validates :symptom, presence: true, if: lambda{|c| c.symptom_id.present? }

  accepts_nested_attributes_for :messages
  mount_uploader :image, ConsultImageUploader

  private

  state_machine initial: :open do
    event :close do
      transition :open => :closed
    end
  end
end

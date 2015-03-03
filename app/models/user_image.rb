class UserImage < ActiveRecord::Base
  belongs_to :user, class_name: 'Member', inverse_of: :user_images
  has_many :messages, inverse_of: :user_image, dependent: :nullify
  has_many :insurance_card_front_insurance_policies, class_name: 'InsurancePolicy', foreign_key: :insurance_card_front_id, inverse_of: :insurance_card_front, dependent: :nullify
  has_many :insurance_card_back_insurance_policies, class_name: 'InsurancePolicy', foreign_key: :insurance_card_back_id, inverse_of: :insurance_card_back, dependent: :nullify
  mount_uploader :image, UserImageUploader

  attr_accessible :user, :user_id, :image, :client_guid, :created_at

  validates :user, presence: true
  validates :client_guid, uniqueness: true, if: ->(u){u.client_guid.present?}

  after_save :set_foreign_references, if: ->(u){u.client_guid.present?}

  def url
    image.url
  end

  private

  def set_foreign_references
    Message.where(user_image_client_guid: client_guid).each do |m|
      m.update_attribute(:user_image_id, id)
    end

    InsurancePolicy.where(insurance_card_front_client_guid: client_guid).each do |ip|
      ip.update_attribute(:insurance_card_front_id, id)
    end

    InsurancePolicy.where(insurance_card_back_client_guid: client_guid).each do |ip|
      ip.update_attribute(:insurance_card_back_id, id)
    end
  end
end

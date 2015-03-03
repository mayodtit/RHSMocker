class InsurancePolicy < ActiveRecord::Base
  include SoftDeleteModule
  belongs_to :user
  belongs_to :insurance_card_front, class_name: 'UserImage', inverse_of: :insurance_card_front_insurance_policies
  belongs_to :insurance_card_back, class_name: 'UserImage', inverse_of: :insurance_card_back_insurance_policies
  attr_accessor :actor

  accepts_nested_attributes_for :insurance_card_front, :insurance_card_back

  attr_accessible :user, :user_id, :company_name, :plan_type, :plan, :group_number,
                  :effective_date, :termination_date, :member_services_number, :family_individual, :employer_individual, :employer_exchange,
                  :authorized, :policy_member_id, :notes, :subscriber_name, :insurance_card_front, :insurance_card_front_id,
                  :insurance_card_back, :insurance_card_back_id, :insurance_card_front_client_guid, :insurance_card_back_client_guid,
                  :insurance_card_front_attributes, :insurance_card_back_attributes, :actor

  validates :user, presence: true
  validates :insurance_card_front, presence: true, if: ->(ip){ip.insurance_card_front_id}
  validates :insurance_card_back, presence: true, if: ->(ip){ip.insurance_card_back_id}

  before_validation :attach_user_image, if: ->(ip){ip.insurance_card_front_client_guid || ip.insurance_card_back_client_guid}, on: :create
  after_create :create_tasks

  private

  def attach_user_image
    self.insurance_card_front ||= UserImage.find_by_client_guid(insurance_card_front_client_guid) if insurance_card_front_client_guid
    self.insurance_card_back ||= UserImage.find_by_client_guid(insurance_card_back_client_guid) if insurance_card_back_client_guid
  end

  def create_tasks
    return unless user.owner.is_premium?
    if @actor == user || user.owner == @actor
      MemberTask.create(title: 'Process insurance',
                        description: 'Insurance card received, process the card',
                        due_at: Time.now + 1.hour,
                        service_type: ServiceType.find_by_name('process insurance card'),
                        member: user.owner,
                        subject: user,
                        owner: user.owner.pha,
                        creator: Member.robot,
                        assignor: Member.robot)
    end
  end
end

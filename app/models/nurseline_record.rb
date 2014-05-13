class NurselineRecord < ActiveRecord::Base
  include SoftDeleteModule

  belongs_to :api_user

  attr_accessible :api_user, :api_user_id, :payload

  validates :api_user, :payload, presence: true

  after_create :create_processing_job

  private

  def create_processing_job
    ProcessNurselineRecordJob.create(id)
  end
end

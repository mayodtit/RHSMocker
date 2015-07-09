class NurselineRecord < ActiveRecord::Base
  include SoftDeleteModule

  belongs_to :api_user

  attr_accessible :api_user, :api_user_id, :payload

  validates :api_user, :payload, presence: true

  after_commit :create_processing_job, on: :create

  private

  def create_processing_job
    ProcessNurselineRecordJob.create(id)
  end
end

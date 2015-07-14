class CreateMayoPilotTaskService < Struct.new(:member)
  MAYO_PILOT_2_TASK_DESCRIPTION = <<-eof
1. Check if you've been assigned a "Review Discharge Plan and save information" task from Paul/Meg
2. Follow up with Paul/Meg if there is no task.
3. Follow "What to do if No Discharge Received" (https://betterpha.squarespace.com/config#/|/stroke-resources/) if you have not been assigned a review discharge form task for patient within 24 hours
  eof

  def call
    MemberTask.create(title: 'Discharge Instructions Follow Up',
                      description: MAYO_PILOT_2_TASK_DESCRIPTION,
                      due_at: 1.business_day.from_now,
                      service_type: ServiceType.find_by_name('other engagement'),
                      member: member,
                      subject: member,
                      owner: member.pha,
                      creator: Member.robot,
                      assignor: Member.robot)
  end
end

class PhoneCallSummaryJob
  def queue_summary(caller_id, consult_id)
    caller = Member.find(caller_id)
    callee = Member.robot
    consult = Consult.find(consult_id)
    PhoneCallSummary.create!(:caller => caller,
                             :callee => callee,
                             :body => 'Phone call summary!',
                             :message_attributes => {
                                                      :user => callee,
                                                      :consult => consult,
                                                      :text => 'Phone call completed with Better Robot'
                                                    }
                            )
  end
  handle_asynchronously :queue_summary, :run_at => Proc.new{ 10.seconds.from_now }
end

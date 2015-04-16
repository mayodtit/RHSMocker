class BirthdayPromotion
  def initialize(member)
    @member = member
  end

  def promote
    case member.status
    when 'free'
      member[:free_trial_ends_at].blank? ? time = Time.now + 2.week : time = member[:free_trial_ends_at] + 2.week
      member.update_attributes(status_event: :grant_free_trial, free_trial_ends_at: time)
      member.save
    when 'trial' 

    when 'premium'

    when 'chamath'

    end
  end

  def member
    @member
  end
end

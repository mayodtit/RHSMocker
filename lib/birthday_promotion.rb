class BirthdayPromotion
  def initialize(member)
    @member = member
  end

  def promote
    case member.status
    when 'free'
      promotion = Promotion.find_by_name('Birthday Promotion')
      unless has_promotion?(promotion)
        member.free_trial_ends_at.blank? ? time = Time.now + 2.week : time = member.free_trial_ends_at + 2.week
        member.update_attributes(status_event: :grant_free_trial, free_trial_ends_at: time)
        member.user_promotions.create(promotion_id: promotion.id)
        member.save
      end
    end
  end

  private

  def member
    @member
  end

  def has_promotion?(promotion)
    member.promotions.include?(promotion)
  end
end

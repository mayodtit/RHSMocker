class BirthdayPromotion
  def initialize(member)
    @member = member
  end

  def promote
    case member.status
    when 'free'
      promo_id = Promotion.find_by_name('Birthday Promotion').id
      byebug
      unless has_promotion?(promo_id)
        member[:free_trial_ends_at].blank? ? time = Time.now + 2.week : time = member[:free_trial_ends_at] + 2.week
        member.update_attributes(status_event: :grant_free_trial, free_trial_ends_at: time)
        member.user_promotions.create(promotion_id: promo_id)
        member.save
      end
    when 'trial' 

    when 'premium'

    when 'chamath'

    end
  end
  
  private 

  def member
    @member
  end

  def has_promotion?(promotion_id)
    promos = member[:user_promotions]
    return false unless promos
    promos.each{ |promo| return true if promo[:promotion_id].eql? promotion_id }
    return false
  end
end

namespace :shutdown do
  task audit: :environment do
    puts "Audit all premium members"

    all_info = Member.premium_states.inject([]) do |collection, member|
      info = {}
      info[:id] = member.id
      info[:email] = member.email
      info[:first_name] = member.first_name
      info[:last_name] = member.last_name
      info[:status] = member.status

      if member.stripe_customer_id
        customer = Stripe::Customer.retrieve(member.stripe_customer_id)
        info[:stripe_id] = member.stripe_customer_id

        subscription = customer.subscriptions.first
        if subscription
          info[:plan] = subscription.plan.id
          info[:period_start] = Time.at(subscription.current_period_start).strftime("%m/%d/%Y")
          info[:period_end] = Time.at(subscription.current_period_end).strftime("%m/%d/%Y")
        end
      end

      collection << info
      print '.'
      collection
    end

    puts "========== FINISHED =========="

    all_info.each do |info|
      puts "#{info[:id]}|#{info[:email]}|#{info[:first_name]}|#{info[:last_name]}|#{info[:status]}|#{info[:stripe_id]}|#{info[:plan]}|#{info[:period_start]}|#{info[:period_end]}"
    end
  end
end

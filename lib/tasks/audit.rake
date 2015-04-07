namespace :audit do
  task members: :environment do
    puts "Overall Counts:"
    counts = Member.group(:status).count
    counts.each do |k, v|
      puts "  #{k}: #{v}"
    end

    puts 'Chamath Users:'
    Member.where(status: :chamath).find_each do |m|
      print_member(m)
    end

    puts 'Premium Members without Stripe Customer IDs:'
    Member.where(status: :premium).where(stripe_customer_id: nil).find_each do |m|
      print_member(m)
    end

    puts 'Premium Members with Stripe Customer IDs:'
    Member.where(status: :premium).where('stripe_customer_id IS NOT NULL').find_each do |m|
      print_member_with_subscription(m)
    end
  end
end

def print_member(member)
  puts "#{member.id},#{member.email},#{member.full_name}"
end

def print_member_with_subscription(member)
  customer = Stripe::Customer.retrieve(member.stripe_customer_id)
  puts "#{member.id},#{member.email},#{member.full_name},#{customer.try(:subscriptions).try(:count)},#{customer.try(:delinquent)}"
end

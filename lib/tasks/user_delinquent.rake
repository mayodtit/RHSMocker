namespace :user_delinquent do
  desc "backfill member's delinquent status"
  task :back_fill_delinquent=> :environment do
    Member.where('delinquent IS NULL').find_each do |member|
      if member.stripe_customer_id
        stripe_customer = Stripe::Customer.retrieve(member.stripe_customer_id)
        member.update_attributes(:delinquent => stripe_customer.delinquent)
      else
        member.update_attributes(:delinquent => false)
      end
    end
  end
end

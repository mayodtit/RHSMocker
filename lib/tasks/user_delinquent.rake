namespace :user_delinquent do
  desc "backfill user's delinquent status"
  task :back_fill_delinquent=> :environment do
    User.where('delinquent IS NULL').find_each do |user|
      if user.stripe_customer_id
        stripe_customer = Stripe::Customer.retrieve(m.stripe_customer_id)
        user.update_attributes(:delinquent => stripe_customer.delinquent)
      else
        user.update_attributes(:delinquent => false)
      end
    end
  end
end

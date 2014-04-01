class AddStripeIdToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :stripe_id, :string
  end
end

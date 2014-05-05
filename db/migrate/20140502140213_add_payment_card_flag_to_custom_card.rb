class AddPaymentCardFlagToCustomCard < ActiveRecord::Migration
  def change
    add_column :custom_cards, :payment_card, :boolean
  end
end

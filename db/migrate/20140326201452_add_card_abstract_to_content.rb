class AddCardAbstractToContent < ActiveRecord::Migration
  def change
    add_column :contents, :card_abstract, :string
  end
end

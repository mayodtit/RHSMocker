class AddCardTemplateToContent < ActiveRecord::Migration
  def change
    add_column :contents, :card_template, :string
  end
end

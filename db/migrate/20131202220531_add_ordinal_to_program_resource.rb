class AddOrdinalToProgramResource < ActiveRecord::Migration
  def change
    add_column :program_resources, :ordinal, :integer
  end
end

class AddTimestampsToProximity < ActiveRecord::Migration
  def change
    add_column :proximities, :created_at, :datetime
    add_column :proximities, :updated_at, :datetime
  end
end

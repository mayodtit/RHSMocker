class CreateSuggestedServices < ActiveRecord::Migration
  def change
    create_table :suggested_services do |t|
      t.belongs_to :user, index: true
      t.belongs_to :service_template, index: true
      t.timestamps
    end
  end
end

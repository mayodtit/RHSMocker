class CreateSuggestedServices < ActiveRecord::Migration
  create_table :suggested_services do |t|
    t.belongs_to :user, index: true
    t.belongs_to :service_template, index: true
    t.timestamps null: false
  end
end

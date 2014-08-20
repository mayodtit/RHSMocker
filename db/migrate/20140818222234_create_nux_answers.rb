class CreateNuxAnswers < ActiveRecord::Migration
  def change
    create_table :nux_answers do |t|
      t.text :name
      t.integer :service_type_id

      t.timestamps
    end
  end
end

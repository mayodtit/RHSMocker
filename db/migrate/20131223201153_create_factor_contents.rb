class CreateFactorContents < ActiveRecord::Migration
  def change
    create_table :factor_contents do |t|
      t.references :factor
      t.references :content
      t.timestamps
    end
  end
end

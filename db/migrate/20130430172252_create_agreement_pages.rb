class CreateAgreementPages < ActiveRecord::Migration
  def change
    create_table :agreement_pages do |t|
      t.text :content
      t.string :page_type

      t.timestamps
    end
  end
end

class CreateHcpTaxonomies < ActiveRecord::Migration
  def change
    create_table :hcp_taxonomies do |t|
      t.string :code
      t.string :hcptype
      t.string :classification
      t.string :specialization
      t.text :definition
      t.text :notes

      t.timestamps
    end
  end
end

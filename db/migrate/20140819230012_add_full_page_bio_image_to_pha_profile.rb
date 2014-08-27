class AddFullPageBioImageToPhaProfile < ActiveRecord::Migration
  def change
    add_column :pha_profiles, :full_page_bio_image, :string
  end
end

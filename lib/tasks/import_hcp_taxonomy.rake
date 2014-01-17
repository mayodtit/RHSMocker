# The Health Care Provider Taxonomy Code Set CSV is located here:
# http://www.nucc.org/index.php?option=com_content&view=article&id=107&Itemid=132
# It's updated twice a year on 1/1 and 7/1.

require 'csv'

namespace :admin do
  task :import_hcp_taxonomy => :environment do
    HCPTaxonomy.destroy_all
    filename = 'nucc_taxonomy_140.csv'
    encoding = 'ISO-8859-1'

    CSV.foreach(Rails.root.join('lib','assets',filename), encoding: encoding, headers: true) do |row|
      HCPTaxonomy.create!(
        code: row['Code'],
        hcptype: row['Type'],
        classification: row['Classification'],
        specialization: row['Specialization'],
        definition: row['Definition'],
        notes: row['Notes']
      )
    end
  end
end
# The Health Care Provider Taxonomy Code Set CSV is located here:
# http://www.nucc.org/index.php?option=com_content&view=article&id=107&Itemid=132
# It's updated twice a year on 1/1 and 7/1.

require 'csv'

filename = 'nucc_taxonomy_150.csv'
encoding = 'ISO-8859-1'

CSV.foreach(Rails.root.join('lib','assets',filename), encoding: encoding, headers: true) do |row|
  HCPTaxonomy.upsert_attributes!({code: row['Code']},
                                 {hcptype: row['Type'],
                                  classification: row['Classification'],
                                  specialization: row['Specialization'],
                                  definition: row['Definition'],
                                  notes: row['Notes']})
end


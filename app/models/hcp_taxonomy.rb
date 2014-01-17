class HCPTaxonomy < ActiveRecord::Base
  attr_accessible :classification, :code, :definition, :hcptype, :notes, :specialization
end

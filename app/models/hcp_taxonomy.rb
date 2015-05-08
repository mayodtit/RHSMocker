class HCPTaxonomy < ActiveRecord::Base
  attr_accessible :classification, :code, :definition, :hcptype, :notes, :specialization

  def self.get_classification_by_hcp_code(code)
    HCPTaxonomy.find_by_code(code).try(:classification)
  end

  def self.for_codes(codes)
    where(code: codes)
  end
end

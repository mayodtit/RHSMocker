require 'spec_helper'

describe Allergy do
  it_has_a 'valid factory'
  it_behaves_like 'model with SOLR index'
  it_validates 'foreign key of', :master_synonym
end

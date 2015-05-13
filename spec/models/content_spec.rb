require 'spec_helper'

describe Content do
  it_has_a 'valid factory'
  it_behaves_like 'model with SOLR index'
  it_validates 'presence of', :title
  it_validates 'presence of', :raw_body
  it_validates 'presence of', :content_type
  it_validates 'presence of', :document_id
  it_validates 'inclusion of', :show_call_option
  it_validates 'inclusion of', :show_checker_option
  it_validates 'inclusion of', :show_mayo_copyright
  it_validates 'inclusion of', :sensitive
  it_validates 'uniqueness of', :document_id
  it_validates 'allows nil inclusion of', :symptom_checker_gender
  it_validates 'foreign key of', :condition

  describe '::random' do
    it 'returns published content with matching content_type' do
      content = create(:content, :published, content_type: Content::CONTENT_TYPES.first)
      described_class.count.should == 1
      described_class.random.should == content
    end

    it 'returns only non-sensitive content' do
      create(:content, :published, content_type: Content::CONTENT_TYPES.first, sensitive: true)
      described_class.count.should == 1
      described_class.random.should be_nil
    end

    it 'returns only published content' do
      create(:content, state: :unpublished)
      described_class.count.should == 1
      described_class.random.should be_nil
    end

    it 'only returns content in Content::CONTENT_TYPES' do
      content = create(:content, state: :published)
      described_class.count.should == 1
      Content::CONTENT_TYPES.should_not include(content.content_type)
      described_class.random.should be_nil
    end

    it 'does not return MayoContent::TERMS_OF_SERVICE' do
      create(:mayo_content, state: :published, document_id: MayoContent::TERMS_OF_SERVICE)
      described_class.count.should == 1
      described_class.random.should be_nil
    end
  end
end

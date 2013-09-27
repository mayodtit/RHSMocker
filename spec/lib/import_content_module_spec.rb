require './lib/import_content_module.rb'
include ImportContentModule

describe ImportContentModule do
  describe '#remove_br_tags' do
    it 'should br tags in string' do
      'ab<br>cd<br />ef'.remove_br_tags.should == 'abcdef'
    end
  end

  describe '#remove_hr_tags' do
    it 'should remove hr tags in string' do
      'ab<hr/>cd<hr />ef'.remove_hr_tags.should == 'abcdef'
    end
  end

  describe '#remove_newlines_and_tabs' do
    it 'should remove \n and \t in string' do
      "ab\ncd\tef".remove_newlines_and_tabs.should == 'abcdef'
    end
  end

  describe '#show_call_for_doc_id?(doc_id)' do
    it 'return true or false given a doc_id (sanity check)' do
      show_call_for_doc_id?('HT00648').should be_false
      show_call_for_doc_id?('foobar').should be_true
    end
  end

  describe '#show_symptom_for_doc_id?(doc_id)' do
    it 'return true or false given a doc_id (sanity check)' do
      show_symptoms_for_doc_id?('HT00648').should be_false
      show_symptoms_for_doc_id?('foobar').should be_true
    end
  end
end
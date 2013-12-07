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

  describe '#remove_leading_numbered_list' do
    it 'should remove "No. 1:" from the beginning of the line' do
      'No. 1: foo'.remove_leading_numbered_list.should == 'foo'
      'No. 42: foo'.remove_leading_numbered_list.should == 'foo'
      'Mambo No. 5: Go!'.remove_leading_numbered_list.should == 'Mambo No. 5: Go!'
    end
  end
end

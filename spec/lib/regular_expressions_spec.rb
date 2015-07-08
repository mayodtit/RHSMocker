require 'spec_helper'

describe RegularExpressions do
  describe '::braces' do
    it 'matches placeholder text' do
      expect("This has a {placeholder}".match(described_class.braces)).to_not be_nil
    end

    it 'matches an open brace' do
      expect("This has a {placeholder".match(described_class.braces)).to_not be_nil
    end

    it 'matches a closed brace' do
      expect("This has a placeholder}".match(described_class.braces)).to_not be_nil
    end
  end

  describe '::brackets' do
    it 'matches placeholder text' do
      expect("This has a [placeholder]".match(described_class.brackets)).to_not be_nil
    end

    it 'matches an open bracket' do
      expect("This has a [placeholder".match(described_class.brackets)).to_not be_nil
    end

    it 'matches a closed bracket' do
      expect("This has a placeholder]".match(described_class.brackets)).to_not be_nil
    end

    it 'allows links' do
      expect("This has a [link](www.google.com)".match(described_class.brackets)).to be_nil
    end

    it 'matches placeholder text with links' do
      expect("This has a [link](www.google.com) and a [placeholder]".match(described_class.brackets)).to_not be_nil
    end

    it 'matches an open bracket with links' do
      expect("This has a [link](www.google.com) and a [placeholder".match(described_class.brackets)).to_not be_nil
    end

    it 'matches a closed bracket with links' do
      expect("This has a [link](www.google.com) and a placeholder]".match(described_class.brackets)).to_not be_nil
    end
  end

  describe '::markdown_link' do
    it 'matches links with erroneous spaces before' do
      expect('[Bad message]( www.google.com)'.match(described_class.markdown_link)).to_not be_nil
    end

    it 'matches links with erroneous spaces after' do
      expect('[Bad message](www.google.com )'.match(described_class.markdown_link)).to_not be_nil
    end

    it 'matches links with erroneous spaces before and after' do
      expect('[Bad message]( www.google.com )'.match(described_class.markdown_link)).to_not be_nil
    end

    it 'does not match well-formed links' do
      expect('[Good message](www.google.com)'.match(described_class.markdown_link)).to be_nil
    end
  end

  describe '::mysql_markdown_link' do
    let(:message) { create(:message) }

    it 'matches links with erroneous spaces before' do
      message.update_attribute(:text, '[Bad message]( www.google.com)')
      expect(Message.where("text REGEXP \"#{described_class.mysql_markdown_link}\"")).to eq([message])
    end

    it 'matches links with erroneous spaces after' do
      message.update_attribute(:text, '[Bad message](www.google.com )')
      expect(Message.where("text REGEXP \"#{described_class.mysql_markdown_link}\"")).to eq([message])
    end

    it 'matches links with erroneous spaces before and after' do
      message.update_attribute(:text, '[Bad message]( www.google.com )')
      expect(Message.where("text REGEXP \"#{described_class.mysql_markdown_link}\"")).to eq([message])
    end

    it 'does not match well-formed links' do
      message.update_attribute(:text, '[Good message](www.google.com)')
      expect(Message.where("text REGEXP \"#{described_class.mysql_markdown_link}\"")).to be_empty
    end
  end
end

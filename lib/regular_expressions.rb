module RegularExpressions
  def self.braces
    /{|}/
  end

  def self.capture_braces
    /{[^}]+}/
  end

  def self.brackets
    /\[(?!.*\]\()|\][^\(]|\]$/
  end

  def self.markdown_link
    /\(\s+(\S*)\s*\)|\(\s*(\S*)\s+\)/
  end

  def self.mysql_markdown_link
    "\\\\([[:space:]].*\\\\)|\\\\(.*[[:space:]]\\\\)"
  end
end

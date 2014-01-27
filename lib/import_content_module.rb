module ImportContentModule
  class ::String
    def remove_br_tags
      self.gsub(/<br( \/)?>/, '')
    end

    def remove_hr_tags
      self.gsub(/<hr ?\/>/, '')
    end

    def remove_newlines_and_tabs
      self.gsub(/\n|\t/, '')
    end

    def remove_leading_numbered_list
      self.gsub(/^No\. \d+: /, '')
    end

    def remove_parens
      self.gsub(/\(.*\)/, '')
    end

    def remove_last_parens
      self.gsub(/\((?!.*\().*\)+$/, '')
    end

    def in_brackets
      self.gsub(/.*\[|\].*/, '')
    end

    def remove_brackets
      self.gsub(/\[.*\]/, '')
    end
  end
end

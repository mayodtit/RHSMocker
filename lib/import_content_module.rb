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
  end
end


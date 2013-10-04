module ImportContentModule

  #############################################################################
  # add methods to String class
  #############################################################################
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
  end

  #############################################################################
  # constants
  #############################################################################

  # these two will not always be the same
  NO_CALL_LIST     = %w(HT00648 AM00021 HT00022 NU00585 NU00584)
  NO_SYMPTOMS_LIST = %w(HT00648 AM00021 HT00022 NU00585 NU00584)

  #############################################################################
  # helper methods
  #############################################################################
  def show_call_for_doc_id?(doc_id)
    !NO_CALL_LIST.include?(doc_id)
  end

  def show_symptoms_for_doc_id?(doc_id)
    !NO_SYMPTOMS_LIST.include?(doc_id)
  end
end


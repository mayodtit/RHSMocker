class MayoContent < Content
  TERMS_OF_SERVICE = 'AM00021'
  CSV_COLUMNS = %w(id document_id content_type title)

  def self.to_csv
    CSV.generate do |csv|
      csv << CSV_COLUMNS
      all.each do |content|
        csv << content.attributes.values_at(*CSV_COLUMNS)
      end
    end
  end

  def self.terms_of_service
    @terms_of_service ||= find_by_document_id('AM00021')
  end

  def content_type_display
    if content_type == 'Disease'
      'Condition'
    else
      super
    end
  end

  private

  def set_defaults
    self.show_call_option = true if show_call_option.nil?
    self.show_checker_option = true if show_checker_option.nil?
    self.show_mayo_copyright = true if show_mayo_copyright.nil?
  end
end

class ParsedNurselineRecordTaskSerializer < TaskSerializer
  attributes :parsed_nurseline_record_id

  def type
    'parsed-nurseline-record'
  end
end

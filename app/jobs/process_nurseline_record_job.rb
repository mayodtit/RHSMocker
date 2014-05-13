class ProcessNurselineRecordJob < Struct.new(:nurseline_record_id)
  def self.create(nurseline_record_id)
    Delayed::Job.enqueue(new(nurseline_record_id))
  end

  def perform
    ParsedNurselineRecord.create_from_nurseline_record(NurselineRecord.find(nurseline_record_id))
  end
end

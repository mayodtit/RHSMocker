class SystemEventTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :title, :description, :state, :unique_id, :version, :sample_ordinal

  delegate :system_relative_event_templates, to: :object

  def sample_ordinal
    if object.respond_to?(:time_offset)
      object.time_offset.calculate(sample_time).to_i
    else
      sample_time.to_i
    end
  end

  private

  def sample_time
    Time.parse('2015-08-12 00:00:00 -0700')
  end
end

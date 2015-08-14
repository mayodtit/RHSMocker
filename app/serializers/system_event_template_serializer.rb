class SystemEventTemplateSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :title, :description, :state, :unique_id, :version

  delegate :system_relative_event_templates, to: :object

  def attributes
    super.tap do |attrs|
      if options[:sample_time]
        attrs[:sample_ordinal] = if object.respond_to?(:time_offset)
                                   object.time_offset.calculate(options[:sample_time]).to_i
                                 else
                                   options[:sample_time].to_i
                                 end
      end
    end
  end
end

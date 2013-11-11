module ActiveModelSerializerExtension
  extend ActiveSupport::Concern

  def active_model_serializer_instance(options={})
    active_model_serializer.try(:new, self, options)
  end
end

ActiveRecord::Base.send(:include, ActiveModelSerializerExtension)
ActiveRecord::Relation.send(:include, ActiveModelSerializerExtension)
Array.send(:include, ActiveModelSerializerExtension)

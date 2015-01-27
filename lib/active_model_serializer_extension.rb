module ActiveModelSerializerExtension
  extend ActiveSupport::Concern

  def serializer(options={})
    active_model_serializer.try(:new, self, options)
  end

  def entry_serializer(options={})
    if self.class.base_class.respond_to?(:safe_constantize)
      active_model_entry_serializer = "#{self.class.base_class.name}EntrySerializer".safe_constantize
    else
      begin
        active_model_entry_serializer="#{self.class.base_class.name}EntrySerializer".constantize
      rescue NameError => e
        raise unless e.message =~ /uninitialized constant/
      end
    end
    active_model_entry_serializer.try(:new, self, options)
  end
end

ActiveRecord::Base.send(:include, ActiveModelSerializerExtension)
ActiveRecord::Relation.send(:include, ActiveModelSerializerExtension)
Array.send(:include, ActiveModelSerializerExtension)

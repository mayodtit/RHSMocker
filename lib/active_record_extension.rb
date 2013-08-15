module ActiveRecordExtension
  extend ActiveSupport::Concern

  module ClassMethods
    def upsert_attributes(key_params, value_params={})
      where(key_params).first_or_initialize.tap{|o| o.update_attributes(value_params)}
    end

    def upsert_attributes!(key_params, value_params={})
      where(key_params).first_or_initialize.tap{|o| o.update_attributes!(value_params)}
    end

    # Allow simple assignment of has_many through join relationships.  Provides the following
    # methods to the ActiveRecord model:
    #   #relation_ids - Get IDs for has_many relation
    #   #relation_ids= - Set IDs for has_many relation.  This must be the canonical set of IDs
    #                    to be set.  IDs that were set before but not present in the arguments
    #                    will be unset.
    def simple_has_many_accessor_for(relation, through)
      accepts_nested_attributes_for through, allow_destroy: true
      attr_accessible "#{relation.to_s.singularize}_ids".to_sym
      attr_accessible "#{through.to_s.singularize}_attributes".to_sym

      define_method("#{relation.to_s.singularize}_ids") do
        send(through).pluck("#{relation.to_s.singularize}_id")
      end

      define_method("#{relation.to_s.singularize}_ids=") do |ids|
        ids ||= []
        ids = ids.reject{|id| send("#{relation.to_s.singularize}_ids").include?(id)}
        attributes = send("removed_#{relation}", ids) +
                     ids.map{|id| {"#{relation.to_s.singularize}_id" => id, self.class.name.underscore => self}}
        send("#{through}_attributes=", attributes)
      end

      define_method("removed_#{relation}") do |ids|
        send(through).reject{|o| ids.include?(o.send("#{relation.to_s.singularize}"))}
                     .map{|o| {id: o.id, _destroy: true}}
      end
      private "removed_#{relation}".to_sym
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecordExtension)

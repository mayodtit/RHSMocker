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
      define_attribute_helpers(relation, through)
      define_mark_for_deletion
      define_mark_for_creation
      define_relation_reader(relation, through)
      define_relation_writer(relation, through)
    end

    def define_attribute_helpers(relation, through)
      accepts_nested_attributes_for through, allow_destroy: true
      attr_accessible "#{relation.to_s.singularize}_ids".to_sym
      attr_accessible "#{through.to_s.singularize}_attributes".to_sym
    end
    private :define_attribute_helpers

    def define_relation_reader(relation, through)
      define_method("#{relation.to_s.singularize}_ids") do
        send(through).pluck("#{relation.to_s.singularize}_id")
      end
    end
    private :define_relation_reader

    def define_relation_writer(relation, through)
      define_method("#{relation.to_s.singularize}_ids=") do |ids|
        ids ||= []
        ids = ids.reject{|id| send("#{relation.to_s.singularize}_ids").include?(id)}
        send("#{through}_attributes=", mark_for_deletion(relation, through, ids) + mark_for_creation(relation, ids))
      end
    end
    private :define_relation_writer

    def define_mark_for_deletion
      define_method(:mark_for_deletion) do |relation, through, ids|
        send(through).reject{|o| ids.include?(o.send(relation.to_s.singularize))}
                     .map{|o| {id: o.id, _destroy: true}}
      end
      private :mark_for_deletion
    end
    private :define_mark_for_deletion

    def define_mark_for_creation
      define_method(:mark_for_creation) do |relation, ids|
        ids.map{|id| {"#{relation.to_s.singularize}_id" => id, self.class.name.underscore => self}}
      end
      private :mark_for_creation
    end
    private :define_mark_for_creation
  end
end

ActiveRecord::Base.send(:include, ActiveRecordExtension)

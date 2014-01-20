module ActiveRecordExtension
  extend ActiveSupport::Concern

  def validate_actor_and_timestamp_exist(event)
    event_s = event.to_s
    actor = event_s.event_actor
    actor_id = event_s.event_actor_id
    state = event_s.event_state
    timestamp = event_s.event_timestamp

    if self.respond_to?(actor_id) && self.send(actor_id).nil?
      errors.add(actor_id, "must be present when #{self.class.name} is #{state}")
    end

    if self.respond_to?(timestamp) && self.send(timestamp).nil?
      errors.add(:timestamp_id, "must be present when #{self.class.name} is #{state}")
    end
  end

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
      define_convert_ids_to_attributes
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
        send("#{through}_attributes=", convert_ids_to_attributes(relation, through, ids))
      end
    end
    private :define_relation_writer

    def define_convert_ids_to_attributes
      define_method(:convert_ids_to_attributes) do |relation, through, ids|
        ids = ids.reject{|id| send("#{relation.to_s.singularize}_ids").include?(id)}
        mark_for_deletion(relation, through, ids) + mark_for_creation(relation, ids)
      end
      private :convert_ids_to_attributes
    end
    private :define_convert_ids_to_attributes

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

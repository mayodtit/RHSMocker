module ActiveRecordExtension
  extend ActiveSupport::Concern

  module ClassMethods
    def upsert_attributes(key_params, value_params={})
      where(key_params).first_or_initialize.tap{|o| o.update_attributes(value_params)}
    end

    def upsert_attributes!(key_params, value_params={})
      where(key_params).first_or_initialize.tap{|o| o.update_attributes!(value_params)}
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecordExtension)

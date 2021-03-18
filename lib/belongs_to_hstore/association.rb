module BelongsToHstore
  module Association
    extend ActiveSupport::Concern
    include BelongsToHstore::HstoreQueryHelper

    included do
      class_attribute :belongs_to_hstore_attributes, instance_accessor: false, instance_predicate: false
      self.belongs_to_hstore_attributes = {}
    end

    module ClassMethods
      def belongs_to_hstore(store_attribute, name, options={})

        self.belongs_to_hstore_attributes = self.belongs_to_hstore_attributes.dup

        key = options[:foreign_key] || "#{name}_id"
        key_type = key.gsub(/_id$/, '_type')

        store_accessor store_attribute, key.to_s
        self.belongs_to_hstore_attributes[key.to_s]= Integer

        if options[:polymorphic]
          store_accessor store_attribute, key_type
          self.belongs_to_hstore_attributes[key_type]= String
        end

        if options = {}
          belongs_to name
        else
          belongs_to name, options
        end

        define_singleton_method("where_#{store_attribute}") do |options|
          where_hstore(store_attribute, options)
        end
      end

    end

    if ActiveRecord::VERSION::STRING.to_f >= 4.2
      def _read_attribute(attr_name)
        if attr_type = self.class.belongs_to_hstore_attributes[attr_name]
          attr_value = send(attr_name)
          if attr_type == Integer
            attr_value = (attr_value.is_a?(String) && attr_value.empty?) ? nil : attr_value.to_i
          end
          attr_value
        else
          super
        end
      end
    else
      def read_attribute(attr_name)
        if attr_type = self.class.belongs_to_hstore_attributes[attr_name]
          attr_value = send(attr_name)
          if attr_type == Integer
            attr_value = (attr_value.is_a?(String) && attr_value.empty?) ? nil : attr_value.to_i
          end
          attr_value
        else
          super
        end
      end
    end

    def write_attribute(attr_name, attr_value)
      if self.class.belongs_to_hstore_attributes[attr_name]
        send("#{attr_name}=", attr_value.to_s)
      else
        super
      end
    end
  end
end
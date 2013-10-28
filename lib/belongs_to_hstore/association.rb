module BelongsToHstore
  module Association
    extend ActiveSupport::Concern
    include BelongsToHstore::HstoreQueryHelper

    module ClassMethods
      def belongs_to_hstore(store_attribute, name, options={})
        @belongs_to_hstore_attributes ||= Set.new
        key = options[:foreign_key] || "#{name}_id"
        key_type = key.gsub(/_id$/, '_type')
        store_accessor store_attribute, key.to_s
        @belongs_to_hstore_attributes.add(key.to_s)

        if options[:polymorphic]
          store_accessor store_attribute, key_type
          @belongs_to_hstore_attributes.add(key_type)
        end
        belongs_to name, options

        define_singleton_method("where_#{store_attribute}") do |options|
          where_hstore(store_attribute, options)
        end
      end

      def belongs_to_hstore_attributes
        attrs = @belongs_to_hstore_attributes || Set.new
        superclass.respond_to?(:belongs_to_hstore_attributes) ? superclass.belongs_to_hstore_attributes + attrs : attrs
      end
    end

    def [](attr_name)
      if self.class.belongs_to_hstore_attributes.include?(attr_name.to_s)
        send(attr_name)
      else
        super
      end
    end

    def []=(attr_name, attr_value)
      if self.class.belongs_to_hstore_attributes.include?(attr_name.to_s)
        send("#{attr_name}=", attr_value.to_s)
      else
        super
      end
    end
  end
end

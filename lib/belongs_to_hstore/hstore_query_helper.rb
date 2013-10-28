module BelongsToHstore
  class HstoreQueryHelper
    extend ActiveSupport::Concern

    module ClassMethods
      def where_hstore(hstore_attribute, opts)
        opts.inject(self) do |scope, opt|
          if opt[1].is_a?(Array)
            values = opt[1].map { |val| val.respond_to?(:id) ? val.id.to_s : val.to_s }
            scope.where("#{table_name}.#{hstore_attribute} -> '#{opt[0]}' IN (?)", values)
          else
            if opt[1].nil?
              value = 'NULL'
            else
              value = opt[1].respond_to?(:id) ? opt[1].id : opt[1]
            end

            scope.where("#{table_name}.#{hstore_attribute} @> '#{opt[0]} => #{value}'")
          end
        end
      end
    end
  end
end

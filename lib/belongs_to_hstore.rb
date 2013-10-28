require 'belongs_to_hstore/version'
require 'belongs_to_hstore/hstore_query_helper'
require 'belongs_to_hstore/association'

module BelongsToHstore
  class Railtie < Rails::Railtie
    initializer "belongs_to_hstore.active_record" do
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send :include, BelongsToHstore::Association
      end
    end
  end
end

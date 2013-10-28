require 'active_record'

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
load File.expand_path("spec/db/schema.rb")

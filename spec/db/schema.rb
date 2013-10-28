ActiveRecord::Schema.define do
  self.verbose = false

  create_table :widgets do |t|
    t.string :name
    t.string :properties
    t.timestamps
  end

  create_table :items do |t|
    t.string :name
    t.timestamps
  end
end

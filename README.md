# BelongsToHstore

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'belongs_to_hstore'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install belongs_to_hstore

## Usage

Add to Gemfile
```ruby
gem 'belongs_to_hstore'
```

Create an association using an hstore column:
```ruby
class Audit < ActiveRecord::Base
  belongs_to_hstore :properties, :item
end
```

Works for polymorphic associations too:
```ruby
class Audit < ActiveRecord::Base
  belongs_to_hstore :properties, :item, :polymorphic => true
end
```

Eager load hstore associations to eliminate N+1 querying:
```ruby
Audit.includes(:item).all
```

Use hstore query helpers to find records:
```ruby
Audit.where_properties(:item_id => 123)
Audit.where_properties(:item_id => [123, 456, 789])
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

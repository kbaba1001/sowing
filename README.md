# Sowing

seed data handling for Rails apps.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sowing'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sowing

## Usage

db/seeds/

```ruby
require 'sowing'

runner = Sowing::Runner.new

# if exist db/seeds/users.(csv|yaml|yml), read data
runner.create(User)

runner.create_or_do_nothing(User, :first_name)
runner.create_or_update(User, :first_name)

# change data root directory
sowing = Sowing::Runner.new(data_directory: Rails.root.join('db/seeds/development'))
```

## Development

### Run tests

    $ bundle exec ruby test/run-test.rb

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kbaba1001/sowing.

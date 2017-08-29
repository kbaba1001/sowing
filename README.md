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

runner.create_or_skip(User, :first_name)
runner.create_or_update(User, :first_name)

# change data root directory
sowing = Sowing::Runner.new(data_directory: Rails.root.join('db/seeds/development'))
```

### Relational Data

For example, the following files exist:

`users.csv`

```csv
first_name,last_name
Carlotta,Wilkinson
中平,薫
```

`profiles.csv`

```csv
user_id,address,phone
"first_name: Carlotta, last_name: Wilkinson","2001 N Clark St, Chicago, IL 60614 America","+1 111-222-3333"
"first_name: 中平, last_name: 薫","東京都新宿区新宿1-1-1","090-1111-2222"
```

And, the ruby code using sowing:

```ruby
require 'sowing'

runner = Sowing::Runner.new

runner.create(User)
runner.create(Profile) do
  mapping :user_id do |cel|
    # cel #=> {'first_name' => 'Carlotta', 'last_name' => 'Wilkinson'}

    User.find_by(
      first_name: cel['first_name'],
      last_name: cel['last_name']
    ).id # Must be return user id
  end
end
```

## Development

### Run tests

    $ bundle exec ruby test/run-test.rb

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kbaba1001/sowing.

## License

MIT

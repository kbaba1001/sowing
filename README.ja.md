# Sowing

seed データの投入、および data migration 時のデータ投入のためのライブラリ。

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sowing'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sowing

## コンセプト

- seedに関わらずどこからでも使える
- CSV, YAML からデータを投入できる
- 投入しようとするデータが既にある場合、何もしないか更新するか選択できる
- Relational Data の投入
- ~~Pure Ruby~~ (現状はまだ Rails 依存のコードがあるが、将来的には Pure Ruby による実装にしたい)
- inspired by [sprig](https://github.com/vigetlabs/sprig)

## 使い方

Sowing を `db/seeds.rb` で使用する例を説明します。

Directories structure example:

```
db
├── seeds
│   ├── books.yml
│   └── users.csv
└── seeds.rb
```

`db/seeds/users.csv`:

```csv
first_name,last_name
Carlotta,Wilkinson
中平,薫
```

`db/seeds/books.yml`:

```yaml
item1:
  name: 'Refactoring: Improving the Design of Existing Code'
  author: 'Martin Fowler'
item2:
  name: 'Webを支える技術'
  author: '山本 陽平'
```

以上のファイルがあるとき `db/seeds.rb` を次のように定義します。

```ruby
require 'sowing'

runner = Sowing::Runner.new

runner.create(User)
runner.create(Book)
```

Sowing では `Sowing::Runner` のインスタンスを使うことでデータ投入を行います。
`#create` メソッドの引数にデータを投入したい Model を渡すと、 sowing は Model を snake cake の複数形に変換した名前で CSV か YAML ファイル を `db/seeds` 以下に探しに行きます。
例えば `User` の場合、 `users.(csv|yaml|yml)` を探します。 (見つからない場合例外を出します)
CSV か YAML ファイルを探索するディレクトリ (data directory) は次の方法で変更できます。

```ruby
# 方法1: Sowing::Runner.new のオプションで指定する
sowing = Sowing::Runner.new(data_directory: 'db/seeds/development')

# 方法2: configure を変更する
Sowing::Configuration.configure do |config|
  config.default_data_directory = 'db/seeds/development'
end
```

### seeds を Rails.env によって変更する

sowing は Rails の `rake db:seed` 機能に関して何もしません。
単にデータ投入の機能を提供するだけです。
そのため、 `Rails.env` によってシードデータとして読み込みたいデータを変更したい場合には、次のようにしてください。

Directories structure example:

```
db
├── seeds/
│   ├── development/
│   │   ├── books.yml
│   │   └── users.csv
│   ├── development.rb
│   ├── production/
│   ├── production.rb
│   ├── test/
│   └── test.rb
└── seeds.rb

```

```ruby
# db/seeds.rb
path = Rails.root.join('db', 'seeds', "#{Rails.env}.rb")
load path if path.exist?

# db/seeds/development.rb
require 'sowing'

sowing = Sowing::Runner.new(data_directory: 'db/seeds/development')

sowing.create(User)
sowing.create(Book)
```

## Sowing::Runner の機能

`Sowing::Runner` の instance methods には次のものがあります。

### create(klass, filename: nil)

引数に与えた `klass` のデータを新規作成します。
`filename` を指定しない場合、`klass` をsnake cake の複数形に変換した名前で CSV か YAML ファイル を `db/seeds` 以下に探しに行きます。(例えば、`klass` が `User` の場合、 `users.(csv|yaml|yml)` を探します。)
`filename` を指定する場合、 `new_users.csv` のように拡張子も含めて指定してください。

### create_or_skip(klass, finding_key, filename: nil)

`#create` とほぼ同じですが、 `finding_key` で指定したカラムでDBを探索して一致するデータが見つかった場合、何もしません。
同じスクリプトを複数回実行する可能性がある場合、 `create` より `create_or_skip` を使用することを推奨します。

例:

```
# 1度も下記のスクリプトを実行していないことを前提とする

runner = Sowing::Runner.new

# 1度目のデータ投入なので、users.csv からデータを投入する
runner.create_or_skip(User, :first_name)

# 上記で投入されたデータが存在するため、何もしない。
runner.create_or_skip(User, :first_name)
```

### create_or_update(klass, finding_key, filename: nil)

`#create_or_skip` とほぼ同じですが、`finding_key` で指定したカラムでDBを探索して一致するデータが見つかった場合、
データを更新します。

例:

```
# 1度も下記のスクリプトを実行していないことを前提とする

runner = Sowing::Runner.new

# 1度目のデータ投入なので、users.csv からデータを投入する
runner.create_or_skip(User, :first_name)

# users.csv と update_users.csv で同じ first_name のデータがある場合は update_users.csv の内容で上書きする
# update_users.csv にしかないデータは新規作成する
runner.create_or_skip(User, :first_name, filename: 'update_users.csv')
```

## Development

### Run tests

    $ bundle exec ruby test/run-test.rb

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kbaba1001/sowing.

## License

MIT

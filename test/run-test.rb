#!/usr/bin/env ruby

## load path
require 'pathname'

base_dir = Pathname(File.dirname(__FILE__)).join('..').expand_path
lib_dir  = base_dir.join('lib')
test_dir = base_dir.join('test')

$LOAD_PATH.unshift(lib_dir)
require 'sowing'

## setup database
require 'active_record'
require 'sqlite3'
require 'database_cleaner'

### migration
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'tmp/activerecord.db')
ActiveRecord::Base.connection.execute('DROP TABLE IF EXISTS users;')
ActiveRecord::Base.connection.execute(<<-SQL)
CREATE TABLE users (id INTEGER PRIMARY KEY , first_name VARCHAR(255), last_name VARCHAR(255));
SQL

### load models
Dir[test_dir.join('fixtures/models/*.rb')].each {|f| require f }

## configure test/unit
require 'test/unit'
require 'byebug'

class Sowing::TestBase < Test::Unit::TestCase
  def self.startup
    DatabaseCleaner[:active_record].strategy = :transaction
    DatabaseCleaner[:active_record].clean_with(:truncation)
  end

  setup do
    DatabaseCleaner[:active_record].start
  end

  teardown do
    DatabaseCleaner[:active_record].clean
  end
end

$VERBOSE = true
$KCODE = 'utf8' unless ''.respond_to?(:encoding)

exit Test::Unit::AutoRunner.run(true, test_dir)

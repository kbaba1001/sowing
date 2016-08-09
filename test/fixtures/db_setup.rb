require 'active_record'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'tmp/activerecord.db')

ActiveRecord::Base.connection.execute('DROP TABLE IF EXISTS users;')
ActiveRecord::Base.connection.execute(<<-SQL)
CREATE TABLE users (id INTEGER PRIMARY KEY , first_name VARCHAR(255), last_name VARCHAR(255));
SQL

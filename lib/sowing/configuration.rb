require 'dry-configurable'

class Sowing::Configuration
  extend Dry::Configurable

  setting :default_data_directory, 'db/seeds/'
  setting :csv_strategy, Sowing::Strategies::ActiveRecordCsv
end

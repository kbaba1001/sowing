require 'dry-configurable'

class Sowing::Configuration
  extend Dry::Configurable

  setting :default_data_directory, 'db/seeds/'
  setting :extensions, %w(csv yaml yml)
  setting :strategies, {
    'csv' => Sowing::Strategies::ActiveRecordCsv,
    'yaml' => Sowing::Strategies::ActiveRecordYaml,
    'yml' => Sowing::Strategies::ActiveRecordYaml
  }
end

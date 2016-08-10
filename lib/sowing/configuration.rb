require 'dry-configurable'

class Sowing::Configuration
  extend Dry::Configurable

  setting :default_data_directory, 'db/seeds/'
end

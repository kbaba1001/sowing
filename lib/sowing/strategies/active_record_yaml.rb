require 'yaml'

module Sowing
  module Strategies
    class ActiveRecordYaml < ActiveRecordAbstract
      def read_data(yaml_filename)
        YAML.load_file(yaml_filename).values
      end
    end
  end
end

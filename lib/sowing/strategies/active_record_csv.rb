require 'csv'

module Sowing
  module Strategies
    class ActiveRecordCsv < ActiveRecordAbstract
      def read_data(csv_filename)
        CSV.read(csv_filename, headers: true)
      end
    end
  end
end

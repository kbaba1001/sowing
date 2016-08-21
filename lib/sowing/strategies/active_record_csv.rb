require 'csv'

module Sowing
  module Strategies
    class ActiveRecordCsv
      def read(klass, csv_filename)
        CSV.read(csv_filename, headers: true).each do |row|
          print 'create: '
          p klass.create!(row.to_hash)
        end
      end
    end
  end
end

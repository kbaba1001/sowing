require 'csv'

module Sowing
  module Strategies
    class ActiveRecordCsv
      def create(klass, csv_filename)
        CSV.read(csv_filename, headers: true).each do |row|
          print 'create: '
          p klass.create!(row.to_hash)
        end
      end

      def create_or_do_nothing(klass, csv_filename, finding_key)
        CSV.read(csv_filename, headers: true).each do |row|
          klass.find_or_create_by!(finding_key => row[finding_key.to_s]) do |object|
            object.update(row.to_hash)

            print 'create: '
            p object
          end
        end
      end
    end
  end
end

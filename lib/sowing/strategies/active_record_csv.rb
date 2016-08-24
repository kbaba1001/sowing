require 'csv'

module Sowing
  module Strategies
    class ActiveRecordCsv
      def create(klass, csv_filename)
        read_csv(csv_filename).each do |row|
          object = klass.create!(row.to_hash)

          print_object_info(object)
        end
      end

      def create_or_do_nothing(klass, csv_filename, finding_key)
        read_csv(csv_filename).each do |row|
          klass.find_or_initialize_by(finding_key => row[finding_key.to_s]) do |object|
            object.update!(row.to_hash)

            print_object_info(object)
          end
        end
      end

      def create_or_update(klass, csv_filename, finding_key)
        read_csv(csv_filename).each do |row|
          object = klass.find_or_initialize_by(finding_key => row[finding_key.to_s])
          object.update!(row.to_hash)

          print_object_info(object)
        end
      end

      private

      def read_csv(csv_filename)
        CSV.read(csv_filename, headers: true)
      end

      def print_object_info(object)
        print 'create: '
        p object
      end
    end
  end
end

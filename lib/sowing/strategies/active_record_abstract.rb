module Sowing
  module Strategies
    class ActiveRecordAbstract < AbstractStrategy
      def create(klass, filename)
        read_data(filename).each do |row|
          object = klass.create!(row.to_hash)

          print_object_info(object)
        end
      end

      def create_or_do_nothing(klass, filename, finding_key)
        read_data(filename).each do |row|
          klass.find_or_initialize_by(finding_key => row[finding_key.to_s]) do |object|
            object.update!(row.to_hash)

            print_object_info(object)
          end
        end
      end

      def create_or_update(klass, filename, finding_key)
        read_data(filename).each do |row|
          object = klass.find_or_initialize_by(finding_key => row[finding_key.to_s])
          object.update!(row.to_hash)

          print_object_info(object)
        end
      end

      private

      def read_data(filename)
        raise NotImplementedError
      end
    end
  end
end

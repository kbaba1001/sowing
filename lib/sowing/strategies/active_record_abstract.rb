module Sowing
  module Strategies
    class ActiveRecordAbstract < AbstractStrategy
      def create(klass, row)
        object = klass.create!(row.to_hash)

        print_object_info(object)
      end

      def create_or_do_nothing(klass, row, finding_key)
        klass.find_or_initialize_by(finding_key => row[finding_key.to_s]) do |object|
          object.update!(row.to_hash)

          print_object_info(object)
        end
      end

      def create_or_update(klass, row, finding_key)
        object = klass.find_or_initialize_by(finding_key => row[finding_key.to_s])
        object.update!(row.to_hash)

        print_object_info(object)
      end
    end
  end
end

module Sowing
  module Strategies
    class AbstractStrategy
      def create(klass, csv_filename)
        raise NotImplementedError
      end

      def create_or_do_nothing(klass, csv_filename, finding_key)
        raise NotImplementedError
      end

      def create_or_update(klass, csv_filename, finding_key)
        raise NotImplementedError
      end

      private

      def print_object_info(object)
        print 'create: '
        p object
      end
    end
  end
end

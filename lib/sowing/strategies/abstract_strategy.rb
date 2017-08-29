module Sowing
  module Strategies
    class AbstractStrategy
      def create(klass, row)
        raise NotImplementedError
      end

      def create_or_do_nothing(klass, row, finding_key)
        raise NotImplementedError
      end

      def create_or_update(klass, row, finding_key)
        raise NotImplementedError
      end

      # @return [Enumerable] object
      def read_data(filename)
        raise NotImplementedError
      end

      private

      def print_object_info(object)
        return if ENV['SOWING_QUIET']

        print 'create: '
        p object
      end
    end
  end
end

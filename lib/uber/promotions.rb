require 'uber/arguments'
require 'uber/request'
require 'uber/promotion'

module Uber
  module API
    module Promotions
      def promotion(*args)
        arguments = Uber::Arguments.new(args)
        perform_with_objects(:get, "/v1/promotions", arguments.options, Promotion)
      end
    end
  end
end

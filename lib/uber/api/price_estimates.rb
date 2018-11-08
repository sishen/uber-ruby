require 'uber/arguments'
require 'uber/api_request'
require 'uber/models/price'

module Uber
  module API
    module PriceEstimates
      def price_estimations(*args)
        arguments = Uber::Arguments.new(args)
        perform_with_objects(:get, "/v1.2/estimates/price", arguments.options, Price)
      end
    end
  end
end

require 'uber/arguments'
require 'uber/api_request'
require 'uber/models/delivery'

module Uber
  module API
    module Deliveries
      include Uber::Utils

      def deliveries(*args)
        arguments = Uber::Arguments.new(args)
        perform_with_objects(:get, "/v1/deliveries", arguments.options, Delivery::Delivery)
      end
    end
  end
end
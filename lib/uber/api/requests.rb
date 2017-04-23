require 'uber/arguments'
require 'uber/api_request'
require 'uber/models/request'
require 'uber/models/receipt'
require 'uber/models/estimate'
require 'uber/models/map'

module Uber
  module API
    module Requests
      def trip_estimate(*args)
        arguments = Uber::Arguments.new(args)
        perform_with_object(:post, "v1/requests/estimate", arguments.options, Estimate)
      end

      def trip_request(*args)
        arguments = Uber::Arguments.new(args)
        perform_with_object(:post, "v1/requests", arguments.options, Request)
      end

      def trip_details(request_id)
        perform_with_object(:get, "v1/requests/#{request_id}", {}, Request)
      end

      def trip_map(request_id)
        perform_with_object(:get, "v1/requests/#{request_id}/map", {}, Map)
      end

      def trip_update(request_id, status)
        perform_with_object(:put, "v1/sandbox/requests/#{request_id}", {status: status}, Request)
      end

      def trip_cancel(request_id)
        perform_with_object(:delete, "v1/requests/#{request_id}", {}, Request)
      end

      def trip_receipt(request_id)
        perform_with_object(:get, "v1.2/requests/#{request_id}/receipt", {}, Receipt)
      end

      alias_method :ride_receipt, :trip_receipt
    end
  end
end

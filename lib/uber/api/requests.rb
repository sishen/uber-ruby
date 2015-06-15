require 'uber/arguments'
require 'uber/api_request'
require 'uber/models/request'
require 'uber/models/map'

module Uber
  module API
    module Requests
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
    end
  end
end

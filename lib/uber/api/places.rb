require 'uber/arguments'
require 'uber/api_request'
require 'uber/models/place'

module Uber
  module API
    module Places
      def places(place_id)
        perform_with_object(:get, "/v1/places/#{place_id}", {}, Place)
      end

      def place_update(place_id, address)
        perform_with_object(:put, "/v1/places/#{place_id}", {address: address}, Place)
      end
    end
  end
end
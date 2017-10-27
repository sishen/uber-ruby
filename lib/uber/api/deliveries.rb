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

      def add_delivery(*args)
        arguments = Uber::Arguments.new(args)
        perform_with_object(:post, "/v1/deliveries", arguments.options, Delivery::Delivery)
      end

      def add_delivery_quote(*args)
        arguments = Uber::Arguments.new(args)
        perform_with_objects(:post, "/v1/deliveries/quote", arguments.options, Delivery::Quote)
      end

      def delivery(delivery_id)
        perform_with_object(:get, "/v1/deliveries/#{delivery_id}", {}, Delivery::Delivery)
      end

      def delivery_receipt(delivery_id)
        delivery_id = delivery_id.is_a?(Delivery::Delivery) ? delivery_id.delivery_id : delivery_id
        perform_with_object(:get, "/v1/deliveries/#{delivery_id}/receipt", {}, Delivery::Receipt)
      end

      def delivery_ratings(delivery_id)
        delivery_id = delivery_id.is_a?(Delivery::Delivery) ? delivery_id.delivery_id : delivery_id
        perform_with_objects(:get, "/v1/deliveries/#{delivery_id}/ratings", {}, Delivery::Rating)
      end

      def add_delivery_rating(delivery_id, *args)
        delivery_id = delivery_id.is_a?(Delivery::Delivery) ? delivery_id.delivery_id : delivery_id
        arguments = Uber::Arguments.new(args)
        perform_without_object(:post, "/v1/deliveries/#{delivery_id}/rating", arguments.options)
      end
    end
  end
end
require 'uber/arguments'
require 'uber/api_request'
require 'uber/models/delivery'

module Uber
  module API
    module Deliveries
      include Uber::Utils

      def list(*args)
        arguments = Uber::Arguments.new(args)
        perform_with_objects(:get, "/v1/deliveries", arguments.options, Delivery::Delivery, self.client)
      end

      def add_delivery(*args)
        arguments = Uber::Arguments.new(args)
        perform_with_object(:post, "/v1/deliveries", arguments.options, Delivery::Delivery, self.client)
      end

      def add_quote(*args)
        arguments = Uber::Arguments.new(args)
        perform_with_objects(:post, "/v1/deliveries/quote", arguments.options, Delivery::Quote, self.client)
      end

      def retrieve(delivery_id)
        perform_with_object(:get, "/v1/deliveries/#{delivery_id}", {}, Delivery::Delivery, self.client)
      end

      def receipt(delivery_id)
        delivery_id = delivery_id.is_a?(Delivery::Delivery) ? delivery_id.delivery_id : delivery_id
        perform_with_object(:get, "/v1/deliveries/#{delivery_id}/receipt", {}, Delivery::Receipt, self.client)
      end

      def ratings(delivery_id)
        delivery_id = delivery_id.is_a?(Delivery::Delivery) ? delivery_id.delivery_id : delivery_id
        perform_with_objects(:get, "/v1/deliveries/#{delivery_id}/ratings", {}, Delivery::Rating, self.client)
      end

      def add_rating(delivery_id, *args)
        delivery_id = delivery_id.is_a?(Delivery::Delivery) ? delivery_id.delivery_id : delivery_id
        arguments = Uber::Arguments.new(args)
        perform_without_object(:post, "/v1/deliveries/#{delivery_id}/rating", arguments.options, self.client)
      end

      def rating_tags(delivery_id)
        delivery_id = delivery_id.is_a?(Delivery::Delivery) ? delivery_id.delivery_id : delivery_id
        perform_with_objects(:get, "/v1/deliveries/#{delivery_id}/rating_tags", {}, Delivery::RatingTag, self.client)
      end

      def cancel(delivery_id)
        delivery_id = delivery_id.is_a?(Delivery::Delivery) ? delivery_id.delivery_id : delivery_id
        perform_without_object(:post, "/v1/deliveries/#{delivery_id}/cancel", {}, self.client)
      end

      def regions
        perform_with_objects(:get, "/v1/deliveries/regions", {}, Delivery::Region, self.client)
      end
    end
  end
end
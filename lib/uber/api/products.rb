# frozen_string_literal: true
require "uber/arguments"
require "uber/api_request"
require "uber/models/product"

module Uber
  module API
    module Products
      def products(*args)
        arguments = Uber::Arguments.new(args)
        perform_with_objects(:get, "/v1/products", arguments.options, Product)
      end

      def apply_surge(product_id, surge_multiplier)
        perform_with_object(
          :put,
          "/v1/sandbox/products/#{product_id}",
          { surge_multiplier: surge_multiplier },
          Product
        )
      end

      def apply_availability(product_id, value)
        perform_with_object(
          :put,
          "/v1/sandbox/products/#{product_id}",
          { drivers_available: value },
          Product
        )
      end
    end
  end
end

require 'uber/arguments'
require 'uber/api_request'
require 'uber/models/promotion'

module Uber
  module API
    module Promotions
      def promotion(*args)
        arguments = Uber::Arguments.new(args)
        perform_with_object(:get, "/v1/promotions", arguments.options, Promotion)
      end
    end
  end
end

require 'uber/arguments'
require 'uber/api_request'
require 'uber/models/time'

module Uber
  module API
    module TimeEstimates
      def time_estimations(*args)
        arguments = Uber::Arguments.new(args)
        perform_with_objects(:get, "/v1/estimates/time", arguments.options, Time)
      end
    end
  end
end

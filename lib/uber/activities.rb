require 'uber/arguments'
require 'uber/request'
require 'uber/activity'

module Uber
  module API
    module Activities
      def history(*args)
        arguments = Uber::Arguments.new(args)
        perform_with_object(:get, "/v1/history", arguments.options, Activity)
      end
    end
  end
end

# frozen_string_literal: true
require "uber/arguments"
require "uber/api_request"
require "uber/models/activity"

module Uber
  module API
    module Activities
      def history(*args)
        arguments = Uber::Arguments.new(args)
        perform_with_object(:get, "/v1.2/history", arguments.options, Activity)
      end
    end
  end
end

require 'uber/arguments'
require 'uber/api_request'
require 'uber/models/user'

module Uber
  module API
    module Me
      def me(*args)
        arguments = Uber::Arguments.new(args)
        perform_with_object(:get, "/v1.2/me", arguments.options, User)
      end
    end
  end
end

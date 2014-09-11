require 'uber/arguments'
require 'uber/request'
require 'uber/user'

module Uber
  module API
    module Me
      def me(*args)
        arguments = Uber::Arguments.new(args)
        perform_with_object(:get, "/v1/me", arguments.options, User)
      end
    end
  end
end

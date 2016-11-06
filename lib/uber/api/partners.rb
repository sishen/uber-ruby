require 'uber/arguments'
require 'uber/api_request'
require 'uber/models/partner'

module Uber
  module API
    module Partners
      include Uber::Utils
      def me(*args)
        arguments = Uber::Arguments.new(args)
        perform_with_object(:get, "v1/partners/me", arguments.options, Uber::Partner::Partner, self.client)
      end

      def payments(*args)
        arguments = Uber::Arguments.new(args)
        perform_with_objects(:get, "/v1/partners/payments", arguments.options, Uber::Partner::Payment, self.client)
      end

      def trips(*args)
        arguments = Uber::Arguments.new(args)
        perform_with_objects(:get, "/v1/partners/trips", arguments.options, Uber::Partner::Trip, self.client)
      end
    end
  end
end

# frozen_string_literal: true
require "faraday"
require "json"

module Uber
  module Response
    class ParseJson < Faraday::Response::Middleware
      WHITESPACE_REGEX = /\A^\s*$\z/

      def parse(body)
        case body
        when WHITESPACE_REGEX, nil
          nil
        else
          JSON.parse(body, symbolize_names: true)
        end
      end

      def on_complete(response)
        if respond_to?(:parse) &&
           !unparsable_status_codes.include?(response.status)
          response.body = parse(response.body)
        end
      end

      def unparsable_status_codes
        [204, 301, 302, 304]
      end
    end
  end
end

Faraday::Response.register_middleware parse_json: Uber::Response::ParseJson

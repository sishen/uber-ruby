# frozen_string_literal: true
require "uber/rate_limit"

module Uber
  # Custom error class for rescuing from all Uber errors
  class Error < StandardError
    attr_reader :code, :rate_limit

    module Code
      AUTHENTICATION_PROBLEM = 32
      MALFORMED_REQUEST            = 400
      UNAUTHORIZED_REQUEST         = 401
      REQUEST_FORBIDDEN            = 403
      RESOURCE_NOT_FOUND           = 404
      UNACCEPTABLE_CONTENT_TYPE    = 406
      INVALID_REQUEST              = 422
      RATE_LIMIT_EXCEEDED          = 429
      INTERVAL_ERROR               = 500
    end

    Codes = Code

    class << self
      # Create a new error from an HTTP response
      #
      # @param response [Faraday::Response]
      # @return [Uber::Error]
      def from_response(response)
        message, code = parse_error(response.body)
        new(message, response.response_headers, code)
      end

      # @return [Hash]
      def errors
        @errors ||= {
          400 => Uber::Error::BadRequest,
          401 => Uber::Error::Unauthorized,
          403 => Uber::Error::Forbidden,
          404 => Uber::Error::NotFound,
          406 => Uber::Error::NotAcceptable,
          422 => Uber::Error::UnprocessableEntity,
          429 => Uber::Error::RateLimited,
          500 => Uber::Error::InternalServerError
        }
      end

      private

      def parse_error(body)
        if body.nil?
          ["", nil]
        elsif body[:error]
          [body[:error], nil]
        elsif body[:errors]
          extract_message_from_errors(body)
        end
      end

      def extract_message_from_errors(body)
        first = Array(body[:errors]).first
        if first.is_a?(Hash)
          [first[:message].chomp, first[:code]]
        else
          [first.chomp, nil]
        end
      end
    end

    # Initializes a new Error object
    #
    # @param exception [Exception, String]
    # @param rate_limit [Hash]
    # @param code [Integer]
    # @return [Uber::Error]
    def initialize(message = "", rate_limit = {}, code = nil)
      super(message)
      @rate_limit = Uber::RateLimit.new(rate_limit)
      @code = code
    end

    class ClientError < self; end

    class ConfigurationError < ::ArgumentError; end

    # Raised when Uber returns the HTTP status code 400
    class BadRequest < ClientError; end

    # Raised when Uber returns the HTTP status code 401
    class Unauthorized < ClientError; end

    # Raised when Uber returns the HTTP status code 403
    class Forbidden < ClientError; end

    # Raised when Uber returns the HTTP status code 404
    class NotFound < ClientError; end

    # Raised when Uber returns the HTTP status code 406
    class NotAcceptable < ClientError; end

    # Raised when Uber returns the HTTP status code 422
    class UnprocessableEntity < ClientError; end

    # Raised when Uber returns the HTTP status code 429
    class RateLimited < ClientError; end

    # Raised when Uber returns a 5xx HTTP status code
    class ServerError < self; end

    # Raised when Uber returns the HTTP status code 500
    class InternalServerError < ServerError; end
  end
end

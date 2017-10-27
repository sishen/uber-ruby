require 'uber/version'
require 'uber/error'
require 'base64'
require 'faraday'
require 'faraday/request/multipart'
require 'uber/parse_json'

module Uber
  class Client
    include Uber::API

    attr_accessor :server_token, :client_id, :client_secret
    attr_accessor :bearer_token
    attr_accessor :sandbox
    attr_accessor :debug

    attr_writer :connection_options, :middleware
    ENDPOINT = 'https://api.uber.com'
    SANDBOX_ENDPOINT = 'https://sandbox-api.uber.com'

    def initialize(options = {})
      options.each do |key, value|
        send(:"#{key}=", value)
      end
      yield(self) if block_given?
      validate_credential_type!
    end

    def bearer_token=(token)
      @bearer_token = Token.new(access_token: token, token_type: Token::BEARER_TYPE)
    end

    def connection_options
      @connection_options ||= {
        :builder => middleware,
        :headers => {
          :accept => 'application/json',
          :user_agent => user_agent,
        },
        :request => {
          :open_timeout => 10,
          :timeout => 30,
        },
      }
    end

    # @return [Boolean]
    def user_token?
      !!(client_id && client_secret)
    end

    # @return [String]
    def user_agent
      @user_agent ||= "Uber Ruby Gem #{Uber::Version}"
    end

    def middleware
      @middleware ||= Faraday::RackBuilder.new do |faraday|
        # Encodes as "application/x-www-form-urlencoded" if not already encoded
        faraday.request :url_encoded
        # Parse JSON response bodies
        faraday.response :parse_json
        faraday.response :logger if self.debug
        # Use instrumentation if available
        faraday.use :instrumentation if defined?(FaradayMiddleware::Instrumentation)
        # Set default HTTP adapter
        faraday.adapter Faraday.default_adapter
      end
    end

    # Perform an HTTP GET request
    def get(path, params = {})
      headers = request_headers(:get, path, params)
      request(:get, path, params, headers)
    end

    # Perform an HTTP POST request
    def post(path, params = {})
      headers = params.values.any? { |value| value.respond_to?(:to_io) } ? request_headers(:post, path, params, {}) : request_headers(:post, path, params)
      request(:post, path, params.to_json, headers)
    end

    # Perform an HTTP PUT request
    def put(path, params = {})
      headers = params.values.any? { |value| value.respond_to?(:to_io) } ? request_headers(:post, path, params, {}) : request_headers(:put, path, params)
      request(:put, path, params.to_json, headers)
    end

    # Perform an HTTP DELETE request
    def delete(path, params = {})
      headers = request_headers(:delete, path, params)
      request(:delete, path, params, headers)
    end

    # Perform an HTTP PATCH request
    def patch(path, params={})
      headers = params.values.any? { |value| value.respond_to?(:to_io) } ? request_headers(:post, path, params, {}) : request_headers(:patch, path, params)
      request(:patch, path, params.to_json, headers)
    end

    # @return [Boolean]
    def bearer_token?
      !!bearer_token
    end

    # @return [Hash]
    def credentials
      {
        server_token:  server_token,
        client_id:     client_id,
        client_secret: client_secret
      }
    end

    # @return [Boolean]
    def credentials?
      credentials.values.all?
    end

    def partners
      @partners ||= Uber::Partner::Client.new self
    end

    def deliveries
      @deliveries ||= Uber::Delivery::Client.new self
    end
    private

    # Ensures that all credentials set during configuration are
    # of a valid type. Valid types are String and Symbol.
    #
    # @raise [Uber::Error::ConfigurationError] Error is raised when
    #   supplied uber credentials are not a String or Symbol.
    def validate_credential_type!
      credentials.each do |credential, value|
        next if value.nil?
        fail(Uber::Error::ConfigurationError.new("Invalid #{credential} specified: #{value.inspect} must be a string or symbol.")) unless value.is_a?(String) || value.is_a?(Symbol)
      end
    end

    # Returns a Faraday::Connection object
    #
    # @return [Faraday::Connection]
    def connection
      @connection ||= Faraday.new(self.sandbox ? SANDBOX_ENDPOINT : ENDPOINT, connection_options)
    end

    def request(method, path, params = {}, headers = {})
      connection.send(method.to_sym, path, params) { |request| request.headers.update(headers) }.env
    rescue Faraday::Error::TimeoutError, Timeout::Error => error
      raise(Uber::Error::RequestTimeout.new(error))
    rescue Faraday::Error::ClientError, JSON::ParserError => error
      fail(Uber::Error.new(error))
    end

    def request_headers(method, path, params = {}, signature_params = params)
      headers = {}
      headers[:accept]        = '*/*'
      headers[:content_type]  = 'application/json; charset=UTF-8'
      if bearer_token?
        headers[:authorization] = bearer_auth_header
      else
        headers[:authorization] = server_auth_header
      end
      headers
    end

    def bearer_auth_header
      token = bearer_token.is_a?(Uber::Token) && bearer_token.bearer? ? bearer_token.access_token : bearer_token
      "Bearer #{token}"
    end

    def server_auth_header
      "Token #{@server_token}"
    end
  end

  module Partner
    class Client
      include Uber::API::Partners
      attr_reader :client
      def initialize(client)
        @client = client
      end
    end
  end
  module Delivery
    class Client
      include Uber::API::Deliveries
      attr_reader :client
      def initialize(client)
        @client = client
      end
    end
  end

end

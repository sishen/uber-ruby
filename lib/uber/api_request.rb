module Uber
  class ApiRequest
    attr_accessor :client, :request_method, :path, :options
    alias_method :verb, :request_method

    # @param client [Uber::Client]
    # @param request_method [String, Symbol]
    # @param path [String]
    # @param options [Hash]
    # @return [Uber::ApiRequest]
    def initialize(client, request_method, path, options = {})
      @client = client
      @request_method = request_method.to_sym
      @path = path
      @options = options
    end

    # @return [Hash]
    def perform
      @client.send(@request_method, @path, @options)
    end

    # @param klass [Class]
    # @param request [Uber::ApiRequest]
    # @return [Object]
    def perform_with_object(klass)
      result = perform
      # https://developer.uber.com/docs/rides/api/v1-requests#http-error-codes
      if [400, 403, 404, 409, 422, 500].include?(result.status)
        raise Uber::Error::BadRequest.new(result.body)
      else
        klass.new(result.body)
      end
    end

    # @param klass [Class]
    # @return [Array]
    def perform_with_objects(klass)
      result = perform

      if [400, 403, 404, 409, 422, 500].include?(result.status)
        raise Uber::Error::BadRequest.new(result.body.values.flatten.last)
      else
        result.body.values.flatten.collect do |element|
          klass.new(element)
        end
      end
    end
  end
end

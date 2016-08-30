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
      if result.status == 200 || result.status == 202 || result.status == 204
        klass.new(result.body)
      else
        raise Uber::Error::UnprocessableEntity.new(result.body)
      end
    end

    # @param klass [Class]
    # @return [Array]
    def perform_with_objects(klass)
      result = perform

      if result.status == 200
        result.body.values.flatten.collect do |element|
          klass.new(element)
        end
      else
        raise Uber::Error::UnprocessableEntity.new(result.body.values.flatten.last)
      end
    end
  end
end

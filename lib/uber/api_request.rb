# frozen_string_literal: true
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
      @client.send(@request_method, @path, @options).body
    end

    # @param klass [Class]
    # @param request [Uber::ApiRequest]
    # @return [Object]
    def perform_with_object(klass)
      klass.new(perform)
    end

    # @param klass [Class]
    # @return [Array]
    def perform_with_objects(klass)
      perform.values.flatten.map do |element|
        klass.new(element)
      end
    end
  end
end

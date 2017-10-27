require 'uber/arguments'
require 'uber/api_request'

module Uber
  module Utils
    # @param request_method [Symbol]
    # @param path [String]
    # @param options [Hash]
    # @param klass [Class]
    def perform_with_object(request_method, path, options, klass, client=self)
      request = Uber::ApiRequest.new(client, request_method, path, options)
      request.perform_with_object(klass)
    end

    # @param request_method [Symbol]
    # @param path [String]
    # @param options [Hash]
    # @param klass [Class]
    def perform_with_objects(request_method, path, options, klass, client=self)
      request = Uber::ApiRequest.new(client, request_method, path, options)
      request.perform_with_objects(klass)
    end

    # @param request_method [Symbol]
    # @param path [String]
    # @param options [Hash]
    def perform_without_object(request_method, path, options, client=self)
      request = Uber::ApiRequest.new(client, request_method, path, options)
      request.perform_without_object
    end
  end
end

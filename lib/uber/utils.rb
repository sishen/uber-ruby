require 'addressable/uri'
require 'uber/arguments'
require 'uber/request'

module Uber
  module Utils
    # @param request_method [Symbol]
    # @param path [String]
    # @param options [Hash]
    # @param klass [Class]
    def perform_with_object(request_method, path, options, klass)
      request = Uber::Request.new(self, request_method, path, options)
      request.perform_with_object(klass)
    end

    # @param request_method [Symbol]
    # @param path [String]
    # @param options [Hash]
    # @param klass [Class]
    def perform_with_objects(request_method, path, options, klass)
      request = Uber::Request.new(self, request_method, path, options)
      request.perform_with_objects(klass)
    end
  end
end

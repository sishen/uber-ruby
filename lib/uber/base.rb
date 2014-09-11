module Uber
  class Base
    attr_reader :attrs
    alias_method :to_h, :attrs

    # Initializes a new object
    #
    # @param attrs [Hash]
    # @return [Uber::Base]
    def initialize(attrs = {})
      attrs.each do |key, value|
        if respond_to?(:"#{key}=")
          send(:"#{key}=", value)
        end
      end
    end

    # Fetches an attribute of an object using hash notation
    #
    # @param method [String, Symbol] Message to send to the object
    def [](method)
      send(method.to_sym)
    rescue NoMethodError
      nil
    end
  end
end

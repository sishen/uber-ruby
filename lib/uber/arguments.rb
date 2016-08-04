# frozen_string_literal: true
module Uber
  class Arguments < Array
    attr_reader :options

    # Initializes a new Arguments object
    #
    # @return [Uber::Arguments]
    def initialize(args)
      @options = args.last.is_a?(::Hash) ? args.pop : {}
      super(args.flatten)
    end
  end
end

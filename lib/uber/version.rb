# frozen_string_literal: true
module Uber
  class Version
    MAJOR = 0
    MINOR = 7
    PATCH = 0

    class << self
      # @return [String]
      def to_s
        [MAJOR, MINOR, PATCH].compact.join(".")
      end
    end
  end
end

# frozen_string_literal: true
require "uber/base"

module Uber
  class Token < Uber::Base
    attr_accessor :access_token, :token_type
    alias_method :to_s, :access_token

    BEARER_TYPE = "bearer".freeze

    # @return [Boolean]
    def bearer?
      token_type == BEARER_TYPE
    end
  end
end

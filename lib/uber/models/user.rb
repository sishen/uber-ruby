# frozen_string_literal: true
module Uber
  class User < Base
    attr_accessor :first_name, :last_name, :email, :picture, :promo_code, :uuid
  end
end

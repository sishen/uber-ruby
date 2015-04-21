module Uber
  class Price < Base
    attr_accessor :product_id, :currency_code, :display_name, :estimate, :low_estimate, :high_estimate, :surge_multipler, :duration, :distance
  end
end

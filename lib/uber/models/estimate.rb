# frozen_string_literal: true
module Uber
  class Estimate < Base
    attr_accessor :pickup_estimate, :price, :trip, :code, :message

    def price=(value)
      @price = value.nil? ? nil : Price.new(value)
    end

    def trip=(value)
      @trip = value.nil? ? nil : Trip.new(value)
    end

    def errors?
      @code && !@code.empty? && @message && !@message.empty?
    end

    def humanized_estimate
      unless pickup_estimate.nil?
        if pickup_estimate.to_i == 1
          "#{pickup_estimate} minute"
        else
          "#{pickup_estimate} minutes"
        end
      end
    end
  end

  class Price < Base
    attr_accessor :surge_confirmation_href,
                  :surge_confirmation_id,
                  :high_estimate,
                  :low_estimate,
                  :minimum,
                  :surge_multiplier,
                  :display,
                  :currency_code
  end

  class Trip < Base
    attr_accessor :distance_unit, :duration_estimate, :distance_estimate
  end
end

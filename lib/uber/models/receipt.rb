module Uber
  class Receipt < Base
    attr_accessor :request_id, :subtotal, :total_charged, :total_owed,
                  :total_fare, :currency_code, :duration, :distance, :distance_label

    def distance=(value)
      @distance = value.to_f if value
    end
  end
end
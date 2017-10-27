module Uber
  module Delivery
    class Receipt < Base
      attr_accessor :charges, :charge_adjustments, :delivery_id, :currency_code, :total_fare
    end
  end
end
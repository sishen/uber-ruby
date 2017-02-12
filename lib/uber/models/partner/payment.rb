module Uber
  module Partner

    class PaymentActivity < Base
      attr_accessor :offset, :limit, :count, :payments

      def payments=(values)
        @payments = values.map { |value| Uber::Partner::Payment.new value }
      end
    end

    class Payment < Base
      attr_accessor :category, :breakdown, :rider_fees, :event_time, :trip_id, :cash_collected,
                    :amount, :driver_id, :partner_id, :currency_code

      def event_time
        ::Time.at @event_time
      end
    end

  end

end
module Uber
  module Delivery
    class Delivery < Base
      attr_accessor :courier, :created_at, :currency_code, :delivery_id,
                    :dropoff, :fee, :items, :order_reference_id, :pickup, :quote_id,
                    :status, :tracking_url, :batch

      def created_at
        @created_at && ::Time.at(@created_at)
      end
    end
  end
end
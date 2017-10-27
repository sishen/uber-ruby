module Uber
  module Delivery
    class Quote < Base
      attr_accessor :quote_id, :estimated_at, :expires_at, :fee, :currency_code,
                    :pickup_eta, :dropoff_eta

      def estimated_at
        @estimated_at && ::Time.at(@estimated_at)
      end

      def expires_at
        @expires_at && ::Time.at(@expires_at)
      end
    end
  end
end
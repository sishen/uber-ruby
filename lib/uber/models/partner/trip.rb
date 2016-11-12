module Uber
  module Partner

    class TripActivity < Base
      attr_accessor :count, :limit, :offset, :trips

      def trips=(values)
        @trips = values.map { |value| Uber::Partner::Trip.new value }
      end
    end

    class Trip < Base
      attr_accessor :dropoff, :vehicle_id, :distance, :start_city, :status_changes, :pickup,
                    :driver_id, :status, :duration, :trip_id

      def status_changes=(values)
        @status_changes = values.map { |value| Uber::Partner::StatusChange.new value }
      end
    end

    class StatusChange < Base
      attr_accessor :status, :timestamp

      def time
        ::Time.at @timestamp if @timestamp
      end
    end
  end
end
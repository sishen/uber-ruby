module Uber
  class Activity < Base
    attr_accessor :offset, :limit, :count, :history

    def history=(value)
      @history = History.new(value)
    end
  end

  class History < Base
    attr_accessor :uuid, :request_time, :product_id, :status, :distance, :start_time, :end_time, :start_location, :end_location

    def start_location=(value)
      @start_location = Location.new(value)
    end

    def end_location=(value)
      @end_location = Location.new(value)
    end
  end

  class Location < Base
    attr_accessor :address, :latitude, :longitude
  end
end

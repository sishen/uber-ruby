module Uber
  class Activity < Base
    attr_accessor :offset, :limit, :count, :histories

    def history=(values)
      @histories = values.map { |value| History.new(value) }
    end
  end

  class History < Base
    attr_accessor :uuid, :request_time, :product_id, :status, :distance, :start_time, :end_time

    def request_time=(value)
      @request_time = ::Time.at(value)
    end

    def start_time=(value)
      @start_time = ::Time.at(value)
    end

    def end_time=(value)
      @end_time = ::Time.at(value)
    end
  end

  class Location < Base
    attr_accessor :address, :latitude, :longitude
  end
end

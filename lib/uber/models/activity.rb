# frozen_string_literal: true
module Uber
  class Activity < Base
    attr_accessor :offset, :limit, :count, :histories

    def history=(values)
      @histories = values.map { |value| History.new(value) }
    end
  end

  class History < Base
    attr_accessor :request_time,
                  :product_id,
                  :status,
                  :distance,
                  :start_time,
                  :end_time,
                  :start_city,
                  :request_id

    alias_method :uuid, :request_id

    def request_time=(value)
      @request_time = ::Time.at(value)
    end

    def start_time=(value)
      @start_time = ::Time.at(value)
    end

    def end_time=(value)
      @end_time = ::Time.at(value)
    end

    def start_city=(value)
      @start_city = City.new(value)
    end
  end

  class Location < Base
    attr_accessor :address, :latitude, :longitude
  end

  class City < Base
    attr_accessor :display_name, :latitude, :longitude
  end
end

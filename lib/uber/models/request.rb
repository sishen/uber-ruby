# frozen_string_literal: true
module Uber
  class Request < Base
    attr_accessor :request_id,
                  :status,
                  :vehicle,
                  :driver,
                  :location,
                  :eta,
                  :surge_multiplier,
                  :meta,
                  :errors

    def driver=(value)
      @driver = value.nil? ? nil : Driver.new(value)
    end

    def vehicle=(value)
      @vehicle = value.nil? ? nil : Vehicle.new(value)
    end

    def location=(value)
      @location = value.nil? ? nil : Location.new(value)
    end

    def error=(value)
      @error = value.nil? ? nil : RequestError.new(value)
    end

    def errors=(values)
      @errors = values.map { |v| RequestError.new(v) }
    end

    def errors?
      @errors && @errors.size >= 1 || @error && @error.key?("code")
    end

    def vehicle_name
      vehicle.nil? ? nil : "#{vehicle.make} #{vehicle.model}"
    end

    def vehicle_image_url
      vehicle.nil? ? nil : vehicle.picture_url.to_s
    end

    def driver_image_url
      driver.nil? ? nil : driver.picture_url.to_s
    end

    def humanized_eta
      !eta.nil? && eta.to_i == 1 ? "#{eta} minute" : "#{eta} minutes"
    end
  end

  class RequestError < Base
    attr_accessor :status, :code, :title, :message
  end

  class Driver < Base
    attr_accessor :phone_number, :rating, :picture_url, :name
  end

  class Vehicle < Base
    attr_accessor :make, :model, :license_plate, :picture_url
  end

  class Location < Base
    attr_accessor :latitude, :longitude, :bearing
  end
end

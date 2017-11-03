module Uber
  module Delivery
    class Region < Base
      attr_accessor :city, :country, :type, :features
    end
  end
end
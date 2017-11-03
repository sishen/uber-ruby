module Uber
  module Delivery
    class Rating < Base
      attr_accessor :waypoint, :rating_type, :rating_value, :tags, :comments
    end
  end
end
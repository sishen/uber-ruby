require 'uber/products'
require 'uber/price_estimates'
require 'uber/time_estimates'
require 'uber/activities'
require 'uber/me'

module Uber
  module API
    include Uber::Utils
    include Uber::API::Products
    include Uber::API::PriceEstimates
    include Uber::API::TimeEstimates
    include Uber::API::Activities
    include Uber::API::Me
  end
end

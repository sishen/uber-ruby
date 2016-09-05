require 'uber/api/products'
require 'uber/api/price_estimates'
require 'uber/api/time_estimates'
require 'uber/api/activities'
require 'uber/api/me'
require 'uber/api/promotions'
require 'uber/api/requests'
require 'uber/api/places'

module Uber
  module API
    include Uber::Utils
    include Uber::API::Products
    include Uber::API::PriceEstimates
    include Uber::API::TimeEstimates
    include Uber::API::Activities
    include Uber::API::Me
    include Uber::API::Promotions
    include Uber::API::Places
    include Uber::API::Requests
  end
end

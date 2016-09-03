module Uber
  class Product < Base
    attr_accessor :product_id, :description, :display_name, :capacity, :image,
                  :cash_enabled, :shared, :price_details
  end
end

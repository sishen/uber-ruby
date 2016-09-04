module Uber
  class Product < Base
    attr_accessor :product_id, :description, :display_name, :capacity, :image,
                  :cash_enabled, :shared, :price_details

    [:cash_enabled, :shared].each do |m|
      define_method("#{m}?") { instance_variable_get("@#{m}") }
    end
  end
end

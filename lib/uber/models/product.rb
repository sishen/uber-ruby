# frozen_string_literal: true
module Uber
  class Product < Base
    attr_accessor :product_id, :description, :display_name, :capacity, :image
  end
end

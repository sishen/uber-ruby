module Uber
  module Partner
    class Partner < Base
      attr_accessor :driver_id, :first_name, :last_name, :phone_number, :email, :picture,
                    :rating, :promo_code, :activation_status
    end
  end
end
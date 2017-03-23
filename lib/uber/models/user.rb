module Uber
  class User < Base
    attr_accessor :first_name, :last_name, :email, :picture, :promo_code, :mobile_verified, :uuid, :rider_id

    def mobile_verified?
      !!self.mobile_verified
    end
  end
end

require "spec_helper"
require "uber"

describe Uber::API::Me do
  let!(:client) { setup_client }

  before do
    stub_uber_request(:get, "v1/me",
                      # From: https://developer.uber.com/v1/endpoints/#user-profile
                      {
                        "first_name" => "Uber",
                        "last_name" => "Developer",
                        "email" => "developer@uber.com",
                        "picture" => "https://cloudfront.net/deadbeef.jpg",
                        "promo_code" => "teypo",
                        "uuid" => "91d81273-45c2-4b57-8124-d0165f8240c0",
                        "mobile_verified" => true
                      })
  end

  it "should return the user profile" do
    profile = client.me
    expect(profile.first_name).to eql "Uber"
    expect(profile.last_name).to eql "Developer"
    expect(profile.email).to eql "developer@uber.com"
    expect(profile.picture).to eql "https://cloudfront.net/deadbeef.jpg"
    expect(profile.promo_code).to eql "teypo"
    expect(profile.uuid).to eql "91d81273-45c2-4b57-8124-d0165f8240c0"
    expect(profile.mobile_verified).to be true
    expect(profile.mobile_verified?).to be true
  end
end

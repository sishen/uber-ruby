require 'spec_helper'
require 'uber'

describe Uber::API::PriceEstimates do
  let!(:client) { setup_client }

  before do
    stub_uber_request(:get, 'v1/estimates/price?start_latitude=0.0&start_longitude=0.5&end_latitude=0.0&end_longitude=0.6',
                      # From: https://developer.uber.com/v1/endpoints/#price-estimates
                      {
                        "prices" => [
                          {
                            "product_id" => "08f17084-23fd-4103-aa3e-9b660223934b",
                            "currency_code" => "USD",
                            "display_name" => "UberBLACK",
                            "estimate" => "$23-29",
                            "low_estimate" => 23,
                            "high_estimate" => 29,
                            "surge_multiplier" => 1,
                            "duration" => 640,
                            "distance" => 5.34
                          },
                          {
                            "product_id" => "9af0174c-8939-4ef6-8e91-1a43a0e7c6f6",
                            "currency_code" => "USD",
                            "display_name" => "UberSUV",
                            "estimate" => "$36-44",
                            "low_estimate" => 36,
                            "high_estimate" => 44,
                            "surge_multiplier" => 1.25,
                            "duration" => 640,
                            "distance" => 5.34
                          },
                          {
                            "product_id" => "aca52cea-9701-4903-9f34-9a2395253acb",
                            "currency_code" => nil,
                            "display_name" => "uberTAXI",
                            "estimate" => "Metered",
                            "low_estimate" => nil,
                            "high_estimate" => nil,
                            "surge_multiplier" => 1,
                            "duration" => 640,
                            "distance" => 5.34
                          },
                          {
                            "product_id" => "a27a867a-35f4-4253-8d04-61ae80a40df5",
                            "currency_code" => "USD",
                            "display_name" => "uberX",
                            "estimate" => "$15",
                            "low_estimate" => 15,
                            "high_estimate" => 15,
                            "surge_multiplier" => 1,
                            "duration" => 640,
                            "distance" => 5.34
                          }
                        ]
                      }
                    )
  end

  it "should return time estimates for various products" do
    estimates = client.price_estimations(start_latitude: 0.0, start_longitude: 0.5, end_latitude: 0.0, end_longitude: 0.6)
    expect(estimates.size).to eql 4

    expect(estimates[0].product_id).to eql "08f17084-23fd-4103-aa3e-9b660223934b"
    expect(estimates[0].display_name).to eql "UberBLACK"
    expect(estimates[0].currency_code).to eql "USD"
    expect(estimates[0].estimate).to eql "$23-29"
    expect(estimates[0].low_estimate).to eql 23
    expect(estimates[0].high_estimate).to eql 29
    expect(estimates[0].surge_multiplier).to eql 1
    expect(estimates[0].duration).to eql 640
    expect(estimates[0].distance).to eql 5.34

    expect(estimates[1].product_id).to eql "9af0174c-8939-4ef6-8e91-1a43a0e7c6f6"
    expect(estimates[1].display_name).to eql "UberSUV"
    expect(estimates[1].currency_code).to eql "USD"
    expect(estimates[1].estimate).to eql "$36-44"
    expect(estimates[1].low_estimate).to eql 36
    expect(estimates[1].high_estimate).to eql 44
    expect(estimates[1].surge_multiplier).to eql 1.25
    expect(estimates[1].duration).to eql 640
    expect(estimates[1].distance).to eql 5.34

    expect(estimates[2].product_id).to eql "aca52cea-9701-4903-9f34-9a2395253acb"
    expect(estimates[2].display_name).to eql "uberTAXI"
    expect(estimates[2].currency_code).to eql nil
    expect(estimates[2].estimate).to eql "Metered"
    expect(estimates[2].low_estimate).to eql nil
    expect(estimates[2].high_estimate).to eql nil
    expect(estimates[2].surge_multiplier).to eql 1
    expect(estimates[2].duration).to eql 640
    expect(estimates[2].distance).to eql 5.34

    expect(estimates[3].product_id).to eql "a27a867a-35f4-4253-8d04-61ae80a40df5"
    expect(estimates[3].display_name).to eql "uberX"
    expect(estimates[3].currency_code).to eql "USD"
    expect(estimates[3].estimate).to eql "$15"
    expect(estimates[3].low_estimate).to eql 15
    expect(estimates[3].high_estimate).to eql 15
    expect(estimates[3].surge_multiplier).to eql 1
    expect(estimates[3].duration).to eql 640
    expect(estimates[3].distance).to eql 5.34
  end
end

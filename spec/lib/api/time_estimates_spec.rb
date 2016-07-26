# frozen_string_literal: true
require "spec_helper"
require "uber"

describe Uber::API::TimeEstimates do
  let!(:client) { setup_client }

  before do
    stub_uber_request(
      :get,
      "v1/estimates/time?start_latitude=0.6&start_longitude=0.6",
      # From: https://developer.uber.com/v1/endpoints/#time-estimates
      "times" => [
        {
          "product_id" => "5f41547d-805d-4207-a297-51c571cf2a8c",
          "display_name" => "UberBLACK",
          "estimate" => 410
        },
        {
          "product_id" => "694558c9-b34b-4836-855d-821d68a4b944",
          "display_name" => "UberSUV",
          "estimate" => 535
        },
        {
          "product_id" => "65af3521-a04f-4f80-8ce2-6d88fb6648bc",
          "display_name" => "uberTAXI",
          "estimate" => 294
        },
        {
          "product_id" => "17b011d3-65be-421d-adf6-a5480a366453",
          "display_name" => "uberX",
          "estimate" => 288
        }
      ]
    )
  end

  it "should return time estimates for various products" do
    estimates = client.time_estimations(start_latitude: 0.6, start_longitude: 0.6) # rubocop:disable Metrics/LineLength
    expect(estimates.size).to eql 4

    expect(estimates[0].product_id).to eql "5f41547d-805d-4207-a297-51c571cf2a8c" # rubocop:disable Metrics/LineLength
    expect(estimates[0].display_name).to eql "UberBLACK"
    expect(estimates[0].estimate).to eql 410

    expect(estimates[1].product_id).to eql "694558c9-b34b-4836-855d-821d68a4b944" # rubocop:disable Metrics/LineLength
    expect(estimates[1].display_name).to eql "UberSUV"
    expect(estimates[1].estimate).to eql 535

    expect(estimates[2].product_id).to eql "65af3521-a04f-4f80-8ce2-6d88fb6648bc" # rubocop:disable Metrics/LineLength
    expect(estimates[2].display_name).to eql "uberTAXI"
    expect(estimates[2].estimate).to eql 294

    expect(estimates[3].product_id).to eql "17b011d3-65be-421d-adf6-a5480a366453" # rubocop:disable Metrics/LineLength
    expect(estimates[3].display_name).to eql "uberX"
    expect(estimates[3].estimate).to eql 288
  end
end

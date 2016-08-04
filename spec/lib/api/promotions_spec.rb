# frozen_string_literal: true
require "spec_helper"
require "uber"

describe Uber::API::Promotions do
  let!(:client) { setup_client }

  before do
    stub_uber_request(:get, "v1/promotions?end_latitude=0.0&end_longitude=0.6&start_latitude=0.0&start_longitude=0.5", # rubocop:disable Metrics/LineLength
                      # From: https://developer.uber.com/v1/endpoints/#promotions
                      "display_text" => "Free ride up to $30",
                      "localized_value" => "$30",
                      "type" => "trip_credit")
  end

  it "should return available promotion" do
    promotion = client.promotion(
      start_latitude: 0.0,
      start_longitude: 0.5,
      end_latitude: 0.0,
      end_longitude: 0.6
    )

    expect(promotion.display_text).to eql "Free ride up to $30"
    expect(promotion.localized_value).to eql "$30"
    expect(promotion.type).to eql "trip_credit"
  end
end

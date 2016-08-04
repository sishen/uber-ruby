# frozen_string_literal: true
require "spec_helper"
require "uber"

describe Uber::API::Activities do
  let!(:client) { setup_client }

  before do
    stub_uber_request(
      :get,
      "v1.2/history",
      # From: https://developer.uber.com/docs/v12-history
      "offset" => 0,
      "limit" => 1,
      "count" => 5,
      "history" => [
        {
          "request_time" => 1_401_884_467,
          "product_id" => "edf5e5eb-6ae6-44af-bec6-5bdcf1e3ed2c",
          "status" => "completed",
          "distance" => 0.0279562,
          "start_time" => 1_401_884_646,
          "end_time" => 1_401_884_732,
          "start_city" => {
            "latitude" => 37.7749295,
            "display_name" => "San Francisco",
            "longitude" => -122.4194155
          },
          "request_id" => "37d57a99-2647-4114-9dd2-c43bccf4c30b"
        }
      ]
    )
  end

  it "should return the user's activities" do
    activity = client.history

    expect(activity.offset).to eql 0
    expect(activity.limit).to eql 1
    expect(activity.count).to eql 5

    expect(activity.histories.size).to eql 1

    expect(activity.histories[0].request_time.to_i).to eql 1_401_884_467
    expect(activity.histories[0].product_id).to eql "edf5e5eb-6ae6-44af-bec6-5bdcf1e3ed2c" # rubocop:disable Metrics/LineLength
    expect(activity.histories[0].status).to eql "completed"
    expect(activity.histories[0].distance).to eql 0.0279562
    expect(activity.histories[0].start_time.to_i).to eql 1_401_884_646
    expect(activity.histories[0].end_time.to_i).to eql 1_401_884_732
    expect(activity.histories[0].request_id).to eql "37d57a99-2647-4114-9dd2-c43bccf4c30b" # rubocop:disable Metrics/LineLength
    expect(activity.histories[0].uuid).to eql "37d57a99-2647-4114-9dd2-c43bccf4c30b" # rubocop:disable Metrics/LineLength
    expect(activity.histories[0].start_city.display_name).to eql "San Francisco"
    expect(activity.histories[0].start_city.latitude).to eql 37.7749295
    expect(activity.histories[0].start_city.longitude).to eql(-122.4194155)
  end
end

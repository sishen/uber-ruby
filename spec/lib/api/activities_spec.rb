require 'spec_helper'
require 'uber'

describe Uber::API::Activities do
  let!(:client) { setup_client }

  before do
    stub_uber_request(:get, 'v1.1/history',
# From: https://developer.uber.com/v1/endpoints/#user-activity-v1-1
{
  "offset" => 0,
  "limit" => 1,
  "count" => 5,
  "history" => [
    {
      "uuid" => "7354db54-cc9b-4961-81f2-0094b8e2d215",
      "request_time" => 1401884467,
      "product_id" => "edf5e5eb-6ae6-44af-bec6-5bdcf1e3ed2c",
      "status" => "completed",
      "distance" => 0.0279562,
      "start_time" => 1401884646,
      "end_time" => 1401884732
    }
  ]
}
                     )
  end

  it "should return the user's activities" do
    activity = client.history

    expect(activity.offset).to eql 0
    expect(activity.limit).to eql 1
    expect(activity.count).to eql 5

    expect(activity.histories.size).to eql 1

    expect(activity.histories[0].uuid).to eql "7354db54-cc9b-4961-81f2-0094b8e2d215"
    expect(activity.histories[0].request_time.to_i).to eql 1401884467
    expect(activity.histories[0].product_id).to eql "edf5e5eb-6ae6-44af-bec6-5bdcf1e3ed2c"
    expect(activity.histories[0].status).to eql "completed"
    expect(activity.histories[0].distance).to eql 0.0279562
    expect(activity.histories[0].start_time.to_i).to eql 1401884646
    expect(activity.histories[0].end_time.to_i).to eql 1401884732
  end
end

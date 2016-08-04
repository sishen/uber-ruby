# frozen_string_literal: true
require "spec_helper"
require "uber"

describe Uber::API::Requests do
  let!(:client) { setup_client }

  describe "#trip_estimate" do
    context "with a error response" do
      before do
        stub_uber_request(
          :post,
          "v1/requests/estimate",
          # From: https://developer.uber.com/docs/v1-requests-estimate
          {
            "code" => "current_trip_exists",
            "message" => "Trip estimates not allowed while the user is currently on a trip." # rubocop:disable Metrics/LineLength
          },
          body: { product_id: "deadbeef", start_latitude: 0.0, start_longitude: 0.5, end_latitude: 0.0, end_longitude: 0.6 }.to_json, # rubocop:disable Metrics/LineLength
          status_code: 403
        )
      end

      it "should submit a request estimate and return a error" do
        request = client.trip_estimate(product_id: "deadbeef", start_latitude: 0.0, start_longitude: 0.5, end_latitude: 0.0, end_longitude: 0.6) # rubocop:disable Metrics/LineLength

        expect(request.code).to eql "current_trip_exists"
        expect(request.message).to eql "Trip estimates not allowed while the user is currently on a trip." # rubocop:disable Metrics/LineLength
        expect(request.errors?).to be true
      end
    end

    context "with a valid response" do
      before do
        stub_uber_request(
          :post,
          "v1/requests/estimate",
          # From: https://developer.uber.com/docs/v1-requests-estimate
          {
            "price" => {
              "surge_confirmation_href" => "https:\/\/api.uber.com\/v1\/surge-confirmations\/7d604f5e", # rubocop:disable Metrics/LineLength
              "high_estimate" => 6,
              "surge_confirmation_id" => "7d604f5e",
              "minimum" => 5,
              "low_estimate" => 5,
              "surge_multiplier" => 1.2,
              "display" => "$5-6",
              "currency_code" => "USD"
            },
            "trip" => {
              "distance_unit" => "mile",
              "duration_estimate" => 540,
              "distance_estimate" => 2.1
            },
            "pickup_estimate" => 2,
          },
          body: { product_id: "deadbeef", start_latitude: 0.0, start_longitude: 0.5, end_latitude: 0.0, end_longitude: 0.6 }.to_json, # rubocop:disable Metrics/LineLength
          status_code: 200
        )
      end

      it "should submit a request estimate" do
        request = client.trip_estimate(product_id: "deadbeef", start_latitude: 0.0, start_longitude: 0.5, end_latitude: 0.0, end_longitude: 0.6) # rubocop:disable Metrics/LineLength
        expect(request.pickup_estimate).to eql 2

        expect(request.price.surge_confirmation_href).to eql "https://api.uber.com/v1/surge-confirmations/7d604f5e" # rubocop:disable Metrics/LineLength
        expect(request.price.high_estimate).to eql 6
        expect(request.price.surge_confirmation_id).to eql "7d604f5e"
        expect(request.price.minimum).to eql 5
        expect(request.price.low_estimate).to eql 5
        expect(request.price.surge_multiplier).to eql 1.2
        expect(request.price.display).to eql "$5-6"
        expect(request.price.currency_code).to eql "USD"

        expect(request.trip.distance_unit).to eql "mile"
        expect(request.trip.duration_estimate).to eql 540
        expect(request.trip.distance_estimate).to eql 2.1
      end
    end
  end

  describe "#trip_request" do
    context "with a valid response" do
      before do
        stub_uber_request(
          :post,
          "v1/requests",
          # From: https://developer.uber.com/docs/rides/api/v1-requests
          {
            "status" => "accepted",
            "driver" => {
              "phone_number" => "(555)555-5555",
              "rating" => 5,
              "picture_url" => "https://d1w2poirtb3as9.cloudfront.net/img.jpeg",
              "name" => "Bob"
            },
            "eta" => 4,
            "location" => {
              "latitude" => 37.776033,
              "longitude" => -122.418143,
              "bearing" => 33
            },
            "vehicle" => {
              "make" => "Bugatti",
              "model" => "Veyron",
              "license_plate" => "I<3Uber",
              "picture_url" => "https://d1w2poirtb3as9.cloudfront.net/car.jpeg",
            },
            "surge_multiplier" => 1.0,
            "request_id" => "b2205127-a334-4df4-b1ba-fc9f28f56c96"
          },
          body: { product_id: "deadbeef", start_latitude: 0.0, start_longitude: 0.5, end_latitude: 0.0, end_longitude: 0.6 }.to_json, # rubocop:disable Metrics/LineLength
          status_code: 201
        )
      end

      it "should submit a request for a ride" do
        request = client.trip_request(product_id: "deadbeef", start_latitude: 0.0, start_longitude: 0.5, end_latitude: 0.0, end_longitude: 0.6) # rubocop:disable Metrics/LineLength
        expect(request.status).to eql "accepted"
        expect(request.eta).to eql 4
        expect(request.surge_multiplier).to eql 1.0
        expect(request.request_id).to eql "b2205127-a334-4df4-b1ba-fc9f28f56c96"

        expect(request.driver.phone_number).to eql "(555)555-5555"
        expect(request.driver.rating).to eql 5
        expect(request.driver.picture_url).to eql "https://d1w2poirtb3as9.cloudfront.net/img.jpeg" # rubocop:disable Metrics/LineLength
        expect(request.driver.name).to eql "Bob"

        expect(request.location.latitude).to eql 37.776033
        expect(request.location.longitude).to eql(-122.418143)
        expect(request.location.bearing).to eql 33

        expect(request.vehicle.make).to eql "Bugatti"
        expect(request.vehicle.model).to eql "Veyron"
        expect(request.vehicle.license_plate).to eql "I<3Uber"
        expect(request.vehicle.picture_url).to eql "https://d1w2poirtb3as9.cloudfront.net/car.jpeg" # rubocop:disable Metrics/LineLength
      end

      context "with a sandbox API" do
        let!(:sandbox_client) { setup_client(sandbox: true) }

        before do
          stub_uber_request(
            :post,
            "v1/requests",
            # From: https://developer.uber.com/docs/rides/api/v1-requests
            {
              "status" => "accepted",
              "driver" => {
                "phone_number" => "(555)555-5555",
                "rating" => 5,
                "picture_url" => "https://d1w2poirtb3as9.cloudfront.net/img.jpeg", # rubocop:disable Metrics/LineLength
                "name" => "Bob"
              },
              "eta" => 4,
              "location" => {
                "latitude" => 37.776033,
                "longitude" => -122.418143,
                "bearing" => 33
              },
              "vehicle" => {
                "make" => "Bugatti",
                "model" => "Veyron",
                "license_plate" => "I<3Uber",
                "picture_url" => "https://d1w2poirtb3as9.cloudfront.net/car.jpeg", # rubocop:disable Metrics/LineLength
              },
              "surge_multiplier" => 1.0,
              "request_id" => "b2205127-a334-4df4-b1ba-fc9f28f56c96"
            },
            body: { product_id: "deadbeef", start_latitude: 0.0, start_longitude: 0.5, end_latitude: 0.0, end_longitude: 0.6 }.to_json, # rubocop:disable Metrics/LineLength
            status_code: 201,
            sandbox: true
          )
        end

        it "should submit a request for a ride" do
          request = sandbox_client.trip_request(product_id: "deadbeef", start_latitude: 0.0, start_longitude: 0.5, end_latitude: 0.0, end_longitude: 0.6) # rubocop:disable Metrics/LineLength
          expect(request.status).to eql "accepted"
          expect(request.eta).to eql 4
          expect(request.surge_multiplier).to eql 1.0
          expect(request.request_id).to eql "b2205127-a334-4df4-b1ba-fc9f28f56c96" # rubocop:disable Metrics/LineLength

          expect(request.driver.phone_number).to eql "(555)555-5555"
          expect(request.driver.rating).to eql 5
          expect(request.driver.picture_url).to eql "https://d1w2poirtb3as9.cloudfront.net/img.jpeg" # rubocop:disable Metrics/LineLength
          expect(request.driver.name).to eql "Bob"

          expect(request.location.latitude).to eql 37.776033
          expect(request.location.longitude).to eql(-122.418143)
          expect(request.location.bearing).to eql 33

          expect(request.vehicle.make).to eql "Bugatti"
          expect(request.vehicle.model).to eql "Veyron"
          expect(request.vehicle.license_plate).to eql "I<3Uber"
          expect(request.vehicle.picture_url).to eql "https://d1w2poirtb3as9.cloudfront.net/car.jpeg" # rubocop:disable Metrics/LineLength
        end
      end
    end

    context 'with a "processing" response' do
      before do
        stub_uber_request(
          :post,
          "v1/requests",
          # From: https://developer.uber.com/docs/rides/api/v1-requests
          {
            status: "processing",
            request_id: "cad219b7-9cfa-4861-b59b-1e1184429b33",
            driver: nil,
            eta: 7,
            location: nil,
            vehicle: nil,
            surge_multiplier: 1.0
          },
          body: { product_id: "deadbeef", start_latitude: 0.0, start_longitude: 0.5, end_latitude: 0.0, end_longitude: 0.6 }.to_json, # rubocop:disable Metrics/LineLength
          status_code: 409
        )
      end

      it "should submit a request for a ride" do
        request = client.trip_request(product_id: "deadbeef", start_latitude: 0.0, start_longitude: 0.5, end_latitude: 0.0, end_longitude: 0.6) # rubocop:disable Metrics/LineLength
        expect(request.status).to eql "processing"
        expect(request.eta).to eql 7
        expect(request.surge_multiplier).to eql 1.0
        expect(request.request_id).to eql "cad219b7-9cfa-4861-b59b-1e1184429b33"

        expect(request.driver).to be_nil
        expect(request.location).to be_nil
        expect(request.vehicle).to be_nil
      end
    end

    context "with a 409 conflict with surge response" do
      before do
        stub_uber_request(
          :post,
          "v1/requests",
          # From: https://developer.uber.com/docs/rides/api/v1-requests
          {
            "meta" => {
              "surge_confirmation" => {
                "href" => "https://api.uber.com/v1/surge-confirmations/e100a670", # rubocop:disable Metrics/LineLength
                "surge_confirmation_id" => "e100a670"
              }
            },
            "errors" => [
              {
                "status" => 409,
                "code" => "surge",
                "title" => "Surge pricing is currently in effect for this product." # rubocop:disable Metrics/LineLength
              }
            ]
          },
          body: { product_id: "deadbeef", start_latitude: 0.0, start_longitude: 0.5, end_latitude: 0.0, end_longitude: 0.6 }.to_json, # rubocop:disable Metrics/LineLength
          status_code: 409
        )
      end

      it "should submit a request for a ride" do
        request = client.trip_request(product_id: "deadbeef", start_latitude: 0.0, start_longitude: 0.5, end_latitude: 0.0, end_longitude: 0.6) # rubocop:disable Metrics/LineLength
        expect(request.errors.size).to eql 1

        expect(request.errors[0].status).to eql 409
        expect(request.errors[0].code).to eql "surge"
        expect(request.errors[0].title).to eql "Surge pricing is currently in effect for this product." # rubocop:disable Metrics/LineLength

        expect(request.meta[:surge_confirmation][:href]).to eql "https://api.uber.com/v1/surge-confirmations/e100a670" # rubocop:disable Metrics/LineLength
        expect(request.meta[:surge_confirmation][:surge_confirmation_id]).to eql "e100a670" # rubocop:disable Metrics/LineLength
      end
    end
  end

  describe "#trip_details" do
    before do
      stub_uber_request(
        :get,
        "v1/requests/deadbeef",
        # From: https://developer.uber.com/docs/rides/api/v1-requests-details
        {
          "status" => "accepted",
          "driver" => {
            "phone_number" => "(555)555-5555",
            "rating" => 5,
            "picture_url" => "https://d1w2poirtb3as9.cloudfront.net/img.jpeg",
            "name" => "Bob"
          },
          "eta" => 4,
          "location" => {
            "latitude" => 37.776033,
            "longitude" => -122.418143,
            "bearing" => 33
          },
          "vehicle" => {
            "make" => "Bugatti",
            "model" => "Veyron",
            "license_plate" => "I<3Uber",
            "picture_url" => "https://d1w2poirtb3as9.cloudfront.net/car.jpeg",
          },
          "surge_multiplier" => 1.0,
          "request_id" => "b2205127-a334-4df4-b1ba-fc9f28f56c96"
        },
        status_code: 200
      )
    end

    it "should show the request for a ride" do
      request = client.trip_details("deadbeef")
      expect(request.status).to eql "accepted"
      expect(request.surge_multiplier).to eql 1.0
      expect(request.eta).to eql 4
      expect(request.request_id).to eql "b2205127-a334-4df4-b1ba-fc9f28f56c96"

      expect(request.driver.phone_number).to eql "(555)555-5555"
      expect(request.driver.rating).to eql 5
      expect(request.driver.picture_url).to eql "https://d1w2poirtb3as9.cloudfront.net/img.jpeg" # rubocop:disable Metrics/LineLength
      expect(request.driver.name).to eql "Bob"

      expect(request.location.latitude).to eql 37.776033
      expect(request.location.longitude).to eql(-122.418143)
      expect(request.location.bearing).to eql 33

      expect(request.vehicle.make).to eql "Bugatti"
      expect(request.vehicle.model).to eql "Veyron"
      expect(request.vehicle.license_plate).to eql "I<3Uber"
      expect(request.vehicle.picture_url).to eql "https://d1w2poirtb3as9.cloudfront.net/car.jpeg" # rubocop:disable Metrics/LineLength
    end
  end

  describe "#trip_current" do
    before do
      stub_uber_request(
        :get,
        "v1/requests/deadbeef",
        # From: https://developer.uber.com/docs/rides/api/v1-requests-details
        {
          "status" => "accepted",
          "driver" => {
            "phone_number" => "(555)555-5555",
            "rating" => 5,
            "picture_url" => "https://d1w2poirtb3as9.cloudfront.net/img.jpeg",
            "name" => "Bob"
          },
          "eta" => 4,
          "location" => {
            "latitude" => 37.776033,
            "longitude" => -122.418143,
            "bearing" => 33
          },
          "vehicle" => {
            "make" => "Bugatti",
            "model" => "Veyron",
            "license_plate" => "I<3Uber",
            "picture_url" => "https://d1w2poirtb3as9.cloudfront.net/car.jpeg",
          },
          "surge_multiplier" => 1.0,
          "request_id" => "b2205127-a334-4df4-b1ba-fc9f28f56c96"
        },
        status_code: 200
      )
    end

    it "should show the request for the current ride" do
      request = client.trip_details("deadbeef")
      expect(request.status).to eql "accepted"
      expect(request.surge_multiplier).to eql 1.0
      expect(request.eta).to eql 4
      expect(request.request_id).to eql "b2205127-a334-4df4-b1ba-fc9f28f56c96"

      expect(request.driver.phone_number).to eql "(555)555-5555"
      expect(request.driver.rating).to eql 5
      expect(request.driver.picture_url).to eql "https://d1w2poirtb3as9.cloudfront.net/img.jpeg" # rubocop:disable Metrics/LineLength
      expect(request.driver.name).to eql "Bob"

      expect(request.location.latitude).to eql 37.776033
      expect(request.location.longitude).to eql(-122.418143)
      expect(request.location.bearing).to eql 33

      expect(request.vehicle.make).to eql "Bugatti"
      expect(request.vehicle.model).to eql "Veyron"
      expect(request.vehicle.license_plate).to eql "I<3Uber"
      expect(request.vehicle.picture_url).to eql "https://d1w2poirtb3as9.cloudfront.net/car.jpeg" # rubocop:disable Metrics/LineLength
    end
  end

  describe "#trip_map" do
    before do
      stub_uber_request(
        :get,
        "v1/requests/deadbeef/map",
        # From: https://developer.uber.com/docs/rides/api/v1-requests-map
        "request_id" => "b5512127-a134-4bf4-b1ba-fe9f48f56d9d",
        "href" => "https://trip.uber.com/abc123"
      )
    end

    it "should show the map for the ride" do
      map = client.trip_map("deadbeef")
      expect(map.request_id).to eql "b5512127-a134-4bf4-b1ba-fe9f48f56d9d"
      expect(map.href).to eql "https://trip.uber.com/abc123"
    end
  end

  describe "#trip_update" do
    let!(:sandbox_client) { setup_client(sandbox: true) }

    before do
      stub_uber_request(
        :put,
        "v1/sandbox/requests/deadbeef",
        # From: https://developer.uber.com/v1/sandbox/
        nil,
        body: { status: "accepted" }.to_json,
        status_code: 204,
        sandbox: true
      )
    end

    it "should update the state of the request in the sandbox" do
      request = sandbox_client.trip_update("deadbeef", "accepted")
      expect(request.class).to eql Uber::Request
    end
  end

  describe "#trip_cancel" do
    let!(:sandbox_client) { setup_client(sandbox: true) }

    before do
      stub_uber_request(
        :delete,
        "v1/requests/deadbeef",
        # From: https://developer.uber.com/docs/rides/sandbox
        nil,
        body: {},
        status_code: 204,
        sandbox: true
      )
    end

    it "should cancel the request in the sandbox" do
      request = sandbox_client.trip_cancel("deadbeef")
      expect(request.class).to eql Uber::Request
    end
  end
end

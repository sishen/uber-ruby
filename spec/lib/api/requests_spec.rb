require 'spec_helper'
require 'uber'

describe Uber::API::Requests do
  let!(:client) { setup_client }

  describe '#trip_request' do
    context 'with a valid response' do
      before do
        stub_uber_request(:post, "v1/requests",
                          # From: https://developer.uber.com/v1/endpoints/#request
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
                             "surge_multiplier" =>  1.0,
                             "request_id" => "b2205127-a334-4df4-b1ba-fc9f28f56c96"
                          },
                          body: 'end_latitude=0.0&end_longitude=0.6&product_id=deadbeef&start_latitude=0.0&start_longitude=0.5',
                          status_code: 201)
      end

      it 'should submit a request for a ride' do
        request = client.trip_request(product_id: 'deadbeef', start_latitude: 0.0, start_longitude: 0.5, end_latitude: 0.0, end_longitude: 0.6)
        expect(request.status).to eql 'accepted'
        expect(request.surge_multiplier).to eql 1.0
        expect(request.request_id).to eql 'b2205127-a334-4df4-b1ba-fc9f28f56c96'

        expect(request.driver.phone_number).to eql '(555)555-5555'
        expect(request.driver.rating).to eql 5
        expect(request.driver.picture_url).to eql  'https://d1w2poirtb3as9.cloudfront.net/img.jpeg'
        expect(request.driver.name).to eql 'Bob'

        expect(request.location.latitude).to eql 37.776033
        expect(request.location.longitude).to eql -122.418143
        expect(request.location.bearing).to eql 33

        expect(request.vehicle.make).to eql 'Bugatti'
        expect(request.vehicle.model).to eql 'Veyron'
        expect(request.vehicle.license_plate).to eql 'I<3Uber'
        expect(request.vehicle.picture_url).to eql 'https://d1w2poirtb3as9.cloudfront.net/car.jpeg'
      end

      context 'with a sandbox API' do
        let!(:sandbox_client) { setup_client(sandbox: true) }

        before do
          stub_uber_request(:post, "v1/requests",
                            # From: https://developer.uber.com/v1/endpoints/#request
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
                               "surge_multiplier" =>  1.0,
                               "request_id" => "b2205127-a334-4df4-b1ba-fc9f28f56c96"
                            },
                            body: 'end_latitude=0.0&end_longitude=0.6&product_id=deadbeef&start_latitude=0.0&start_longitude=0.5',
                            status_code: 201,
                            sandbox: true)
        end

        it 'should submit a request for a ride' do
          request = sandbox_client.trip_request(product_id: 'deadbeef', start_latitude: 0.0, start_longitude: 0.5, end_latitude: 0.0, end_longitude: 0.6)
          expect(request.status).to eql 'accepted'
          expect(request.surge_multiplier).to eql 1.0
          expect(request.request_id).to eql 'b2205127-a334-4df4-b1ba-fc9f28f56c96'

          expect(request.driver.phone_number).to eql '(555)555-5555'
          expect(request.driver.rating).to eql 5
          expect(request.driver.picture_url).to eql  'https://d1w2poirtb3as9.cloudfront.net/img.jpeg'
          expect(request.driver.name).to eql 'Bob'

          expect(request.location.latitude).to eql 37.776033
          expect(request.location.longitude).to eql -122.418143
          expect(request.location.bearing).to eql 33

          expect(request.vehicle.make).to eql 'Bugatti'
          expect(request.vehicle.model).to eql 'Veyron'
          expect(request.vehicle.license_plate).to eql 'I<3Uber'
          expect(request.vehicle.picture_url).to eql 'https://d1w2poirtb3as9.cloudfront.net/car.jpeg'
        end
      end
    end

    context 'with a 409 conflict with surge response' do
      before do
        stub_uber_request(:post, "v1/requests",
                          # From: https://developer.uber.com/v1/endpoints/#request
                          {
                             "meta" => {
                                "surge_confirmation" => {
                                   "href" => "https://api.uber.com/v1/surge-confirmations/e100a670",
                                   "surge_confirmation_id" => "e100a670"
                                }
                             },
                             "errors" =>[
                                {
                                   "status" => 409,
                                   "code" => "surge",
                                   "title" => "Surge pricing is currently in effect for this product."
                                }
                             ]
                          },
                          body: 'end_latitude=0.0&end_longitude=0.6&product_id=deadbeef&start_latitude=0.0&start_longitude=0.5',
                          status_code: 409)
      end

      it 'should submit a request for a ride' do
        request = client.trip_request(product_id: 'deadbeef', start_latitude: 0.0, start_longitude: 0.5, end_latitude: 0.0, end_longitude: 0.6)
        expect(request.errors.size).to eql 1

        expect(request.errors[0].status).to eql 409
        expect(request.errors[0].code).to eql 'surge'
        expect(request.errors[0].title).to eql "Surge pricing is currently in effect for this product."

        expect(request.meta[:surge_confirmation][:href]).to eql "https://api.uber.com/v1/surge-confirmations/e100a670"
        expect(request.meta[:surge_confirmation][:surge_confirmation_id]).to eql "e100a670"
      end
    end
  end

  describe '#trip_details' do
    before do
      stub_uber_request(:get, "v1/requests/deadbeef",
                        # From: https://developer.uber.com/v1/endpoints/#request-details
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
                           "surge_multiplier" =>  1.0,
                           "request_id" => "b2205127-a334-4df4-b1ba-fc9f28f56c96"
                        },
                        status_code: 200)
    end

    it 'should show the request for a ride' do
      request = client.trip_details('deadbeef')
      expect(request.status).to eql 'accepted'
      expect(request.surge_multiplier).to eql 1.0
      expect(request.request_id).to eql 'b2205127-a334-4df4-b1ba-fc9f28f56c96'

      expect(request.driver.phone_number).to eql '(555)555-5555'
      expect(request.driver.rating).to eql 5
      expect(request.driver.picture_url).to eql  'https://d1w2poirtb3as9.cloudfront.net/img.jpeg'
      expect(request.driver.name).to eql 'Bob'

      expect(request.location.latitude).to eql 37.776033
      expect(request.location.longitude).to eql -122.418143
      expect(request.location.bearing).to eql 33

      expect(request.vehicle.make).to eql 'Bugatti'
      expect(request.vehicle.model).to eql 'Veyron'
      expect(request.vehicle.license_plate).to eql 'I<3Uber'
      expect(request.vehicle.picture_url).to eql 'https://d1w2poirtb3as9.cloudfront.net/car.jpeg'
    end
  end

  describe '#trip_map' do
    before do
      stub_uber_request(:get, "v1/requests/deadbeef/map",
                        # From: https://developer.uber.com/v1/endpoints/#request-map
                        {
                          "request_id" => "b5512127-a134-4bf4-b1ba-fe9f48f56d9d",
                          "href" => "https://trip.uber.com/abc123"
                        })
    end

    it 'should show the map for the ride' do
      map = client.trip_map('deadbeef')
      expect(map.request_id).to eql "b5512127-a134-4bf4-b1ba-fe9f48f56d9d"
      expect(map.href).to eql "https://trip.uber.com/abc123"
    end
  end
end

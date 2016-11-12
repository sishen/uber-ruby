require "spec_helper"
require "uber"


describe Uber::API::Partners do
  let!(:client) { setup_client }

  describe "profile" do
    before do
      stub_uber_request(:get, 'v1/partners/me',
                        {"driver_id" => "3ag923b1-ff5d-4422-80da-a5cefdca3cea",
                         "first_name" => "John",
                         "last_name" => "Driver",
                         "phone_number" => "+12345678901",
                         "email" => "john@example.com",
                         "picture" => "https://subdomain.cloudfront.net/default.jpeg",
                         "rating" => 4.9,
                         "promo_code" => "join_john_on_uber",
                         "activation_status" => "active"
                        }
      )
    end
    it 'should give profile of authenticated driver' do
      driver = client.partners.me
      expect(driver).to be_instance_of Uber::Partner::Partner
      expect(driver.driver_id).to eql "3ag923b1-ff5d-4422-80da-a5cefdca3cea"
      expect(driver.first_name).to eql 'John'
      expect(driver.last_name).to eql 'Driver'
      expect(driver.phone_number).to eql "+12345678901"
      expect(driver.email).to eql 'john@example.com'
      expect(driver.rating).to eql 4.9
      expect(driver.picture).to eql "https://subdomain.cloudfront.net/default.jpeg"
      expect(driver.promo_code).to eql "join_john_on_uber"
      expect(driver.activation_status).to eql 'active'
    end

  end

  describe "payments" do
    describe 'without options' do
      before do
        stub_uber_request(:get, 'v1/partners/payments',
                          {"offset" => 0,
                           "limit" => 2,
                           "count" => 123,
                           "payments" => [{"category" => "fare",
                                           "breakdown" => {"other" => 6.83,
                                                           "toll" => 2,
                                                           "service_fee" => -1.2},
                                           "rider_fees" => {"split_fare" => 0.5},
                                           "event_time" => 1465224550,
                                           "trip_id" => "c72787af",
                                           "cash_collected" => 7.63,
                                           "amount" => 7.63,
                                           "driver_id" => "8LaCLRbV",
                                           "partner_id" => "8LaCLRbV",
                                           "currency_code" => "USD"},
                                          {"category" => "device_payment",
                                           "breakdown" => {"other" => 0},
                                           "event_time" => 1465646574,
                                           "trip_id" => nil,
                                           "cash_collected" => 0,
                                           "amount" => -5,
                                           "driver_id" => "8LaCLRbV",
                                           "rider_fees" => {},
                                           "partner_id" => "8LaCLRbV",
                                           "currency_code" => "USD"}]
                          }
        )
      end

      it 'should return information about payments' do
        payments = client.partners.payments
        expect(payments).to be_instance_of Uber::Partner::PaymentActivity
        expect(payments.payments).to be_instance_of Array
        expect(payments.payments.length).to eql 2
        expect(payments.payments.length).to eql [payments.count, payments.limit].min
        expect(payments.offset).to eql 0
        expect(payments.limit).to eql 2
        expect(payments.count).to eql 123
        payment = payments.payments.first
        expect(payment).to be_instance_of Uber::Partner::Payment
        expect(payment.category).to eql 'fare'
        expect(payment.event_time).to eql Time.at(1465224550)
        expect(payment.trip_id).to eql 'c72787af'
        expect(payment.cash_collected).to eql 7.63
        expect(payment.amount).to eql 7.63
        expect(payment.driver_id).to eql '8LaCLRbV'
        expect(payment.partner_id).to eql '8LaCLRbV'
        expect(payment.currency_code).to eql 'USD'
      end
    end

    describe 'with options' do
      before do
        stub_uber_request(:get, 'v1/partners/payments?limit=1&offset=1',
                          {"offset" => 1,
                           "limit" => 1,
                           "count" => 123,
                           "payments" => [{"category" => "device_payment",
                                           "breakdown" => {"other" => 0},
                                           "event_time" => 1465646574,
                                           "trip_id" => nil,
                                           "cash_collected" => 0,
                                           "amount" => -5,
                                           "driver_id" => "8LaCLRbV",
                                           "rider_fees" => {},
                                           "partner_id" => "8LaCLRbV",
                                           "currency_code" => "USD"}]
                          }
        )
      end

      it 'should return information about payments with correct limits' do
        payments = client.partners.payments(:limit => 1, :offset => 1)
        expect(payments).to be_instance_of Uber::Partner::PaymentActivity
        expect(payments.payments).to be_instance_of Array
        expect(payments.payments.length).to eql 1
        expect(payments.payments.length).to eql [payments.count, payments.limit].min
        expect(payments.offset).to eql 1
        expect(payments.limit).to eql 1
        expect(payments.count).to eql 123
        payment = payments.payments.first
        expect(payment).to be_instance_of Uber::Partner::Payment
        expect(payment.category).to eql 'device_payment'
        expect(payment.event_time).to eql Time.at(1465646574)
        expect(payment.trip_id).to eql nil
        expect(payment.cash_collected).to eql 0
        expect(payment.amount).to eql -5
        expect(payment.driver_id).to eql '8LaCLRbV'
        expect(payment.partner_id).to eql '8LaCLRbV'
        expect(payment.currency_code).to eql 'USD'
      end
    end
  end

  describe "trips" do
    describe 'without options' do
      before do
        stub_uber_request(:get, 'v1/partners/trips',
                          {"count" => 1,
                           "limit" => 10,
                           "offset" => 0,
                           "trips" => [{"dropoff" => {"timestamp" => 1455912051},
                                        "vehicle_id" => "e6d1e6e8-fb19-49b5-b0a9-690672dab458",
                                        "distance" => 0,
                                        "start_city" => {"latitude" => 37.7749,
                                                         "display_name" => "San Francisco",
                                                         "longitude" => -122.4194},
                                        "status_changes" => [{"status" => "accepted",
                                                              "timestamp" => 1455910811},
                                                             {"status" => "driver_arrived",
                                                              "timestamp" => 1455910831},
                                                             {"status" => "trip_began",
                                                              "timestamp" => 1455910832},
                                                             {"status" => "completed",
                                                              "timestamp" => 1455912051}],
                                        "pickup" => {"timestamp" => 1455910832},
                                        "driver_id" => "8GhJMmFh8fxRCsIlzf8kY12cJx97COSXldXaCHRLfha_7UM8jyR3SVJyGSaV-eFlXpf2Fa6rAo15bQ_gkHq-5lS5D9CaCmHRTjycmUxiaC0ee1iTlJ1v7R5GydCONS46IA==",
                                        "status" => "completed",
                                        "duration" => 1220,
                                        "trip_id" => "e33f756b-16e9-4cb4-96d4-ef0d0e5c9838"}]}
        )
      end

      it 'should return information about trips' do
        trips = client.partners.trips
        expect(trips).to be_instance_of Uber::Partner::TripActivity
        expect(trips.trips).to be_instance_of Array
        expect(trips.trips.length).to eql 1
        expect(trips.trips.length).to eql [trips.count, trips.limit].min
        expect(trips.count).to eql 1
        expect(trips.limit).to eql 10
        expect(trips.offset).to eql 0

        trip = trips.trips.first
        expect(trip).to be_instance_of Uber::Partner::Trip
        expect(trip.dropoff[:timestamp]).to eql 1455912051
        expect(trip.vehicle_id).to eql "e6d1e6e8-fb19-49b5-b0a9-690672dab458"
        expect(trip.distance).to eql 0
        expect(trip.start_city[:latitude]).to eql 37.7749
        expect(trip.start_city[:display_name]).to eql 'San Francisco'
        expect(trip.start_city[:longitude]).to eql -122.4194
        expect(trip.pickup[:timestamp]).to eql 1455910832
        expect(trip.driver_id).to eql  "8GhJMmFh8fxRCsIlzf8kY12cJx97COSXldXaCHRLfha_7UM8jyR3SVJyGSaV-eFlXpf2Fa6rAo15bQ_gkHq-5lS5D9CaCmHRTjycmUxiaC0ee1iTlJ1v7R5GydCONS46IA=="
        expect(trip.status).to eql 'completed'
        expect(trip.duration).to eql 1220
        expect(trip.trip_id).to eql "e33f756b-16e9-4cb4-96d4-ef0d0e5c9838"

        status_change = trip.status_changes.first
        expect(status_change).to be_instance_of Uber::Partner::StatusChange
        expect(status_change.status).to eq 'accepted'
        expect(status_change.timestamp).to eq 1455910811
        expect(status_change.time).to eq ::Time.at(1455910811)
      end

    end

    describe 'with options' do
      before do
        stub_uber_request(:get, 'v1/partners/trips?offset=1&limit=1',
                          {"count" => 1,
                           "limit" => 1,
                           "offset" => 1,
                           "trips" => [{"dropoff" => {"timestamp" => 1455912051},
                                        "vehicle_id" => "e6d1e6e8-fb19-49b5-b0a9-690672dab458",
                                        "distance" => 0,
                                        "start_city" => {"latitude" => 37.7749,
                                                         "display_name" => "San Francisco",
                                                         "longitude" => -122.4194},
                                        "status_changes" => [{"status" => "accepted",
                                                              "timestamp" => 1455910811},
                                                             {"status" => "driver_arrived",
                                                              "timestamp" => 1455910831},
                                                             {"status" => "trip_began",
                                                              "timestamp" => 1455910832},
                                                             {"status" => "completed",
                                                              "timestamp" => 1455912051}],
                                        "pickup" => {"timestamp" => 1455910832},
                                        "driver_id" => "8GhJMmFh8fxRCsIlzf8kY12cJx97COSXldXaCHRLfha_7UM8jyR3SVJyGSaV-eFlXpf2Fa6rAo15bQ_gkHq-5lS5D9CaCmHRTjycmUxiaC0ee1iTlJ1v7R5GydCONS46IA==",
                                        "status" => "completed",
                                        "duration" => 1220,
                                        "trip_id" => "e33f756b-16e9-4cb4-96d4-ef0d0e5c9838"}]}
        )
      end

      it 'should return information about trips with limits' do
        trips = client.partners.trips(:offset => 1, :limit => 1)
        expect(trips.count).to eql 1
        expect(trips.limit).to eql 1
        expect(trips.offset).to eql 1
        expect(trips.trips.length).to eql [trips.limit, trips.count].min
      end

    end
  end
end



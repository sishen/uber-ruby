require 'spec_helper'
require 'uber'

describe Uber::API::Products do
  let!(:client) { setup_client }

  describe '#products' do
    context 'with a valid response' do
      before do
        stub_uber_request(:get, "v1/products",
                          # From: https://developer.uber.com/v1/endpoints/#product-types
                          {
                            "products" => [
                              {
                                "capacity" => 4,
                                "description" => "The low-cost Uber",
                                "price_details" => {
                                  "distance_unit" => "mile",
                                  "cost_per_minute" => 0.26,
                                  "service_fees" => [
                                    {
                                      "fee" => 1.0,
                                      "name" => "Safe Rides Fee"
                                    }
                                  ],
                                  "minimum" => 5.0,
                                  "cost_per_distance" => 1.3,
                                  "base" => 2.2,
                                  "cancellation_fee" => 5.0,
                                  "currency_code" => "USD"
                                },
                                "image" => "http://d1a3f4spazzrp4.cloudfront.net/car.jpg",
                                "display_name" => "uberX",
                                "product_id" => "a1111c8c-c720-46c3-8534-2fcdd730040d",
                                "shared" => true,
                                "cash_enabled" => true
                              },
                              {
                                "capacity" => 6,
                                "description" => "low-cost rides for large groups",
                                "price_details" => {
                                  "distance_unit" => "mile",
                                  "cost_per_minute" => 0.45,
                                  "service_fees" => [
                                    {
                                      "fee" => 1.0,
                                      "name" => "Safe Rides Fee"
                                    }
                                  ],
                                  "minimum" => 8.0,
                                  "cost_per_distance" => 2.15,
                                  "base" => 5.0,
                                  "cancellation_fee" => 5.0,
                                  "currency_code" => "USD"
                                },
                                "image" => "http://d1a3f4spazzrp4.cloudfront.net/car.jpg",
                                "display_name" => "uberXL",
                                "product_id" => "821415d8-3bd5-4e27-9604-194e4359a449",
                                "shared" => true,
                                "cash_enabled" => true
                              },
                              {
                                "capacity" => 4,
                                "description" => "The original Uber",
                                "price_details" => {
                                  "distance_unit" => "mile",
                                  "cost_per_minute" => 0.65,
                                  "service_fees" => [],
                                  "minimum" => 15.0,
                                  "cost_per_distance" => 3.75,
                                  "base" => 8.0,
                                  "cancellation_fee" => 10.0,
                                  "currency_code" => "USD"
                                },
                                "image" => "http://d1a3f4spazzrp4.cloudfront.net/car.jpg",
                                "display_name" => "UberBLACK",
                                "product_id" => "d4abaae7-f4d6-4152-91cc-77523e8165a4",
                                "shared" => false,
                                "cash_enabled" => true
                              },
                              {
                                "capacity" => 6,
                                "description" => "Room for everyone",
                                "price_details" => {
                                  "distance_unit" => "mile",
                                  "cost_per_minute" => 0.9,
                                  "service_fees" => [],
                                  "minimum" => 25.0,
                                  "cost_per_distance" => 3.75,
                                  "base" => 15.0,
                                  "cancellation_fee" => 10.0,
                                  "currency_code" => "USD"
                                },
                                "image" => "http://d1a3f4spazzrp4.cloudfront.net/car.jpg",
                                "display_name" => "UberSUV",
                                "product_id" => "8920cb5e-51a4-4fa4-acdf-dd86c5e18ae0",
                                "shared" => true,
                                "cash_enabled" => false
                              },
                              {
                                "capacity" => 4,
                                "description" => "Taxi without the hassle",
                                "price_details" => nil,
                                "image" => "http://d1a3f4spazzrp4.cloudfront.net/car.jpg",
                                "display_name" => "uberTAXI",
                                "product_id" => "3ab64887-4842-4c8e-9780-ccecd3a0391d",
                                "shared" => false,
                                "cash_enabled" => false
                              }
                            ]
                          }
                         )
      end

      it 'should list all the products' do
        products = client.products
        expect(products.size).to eql 5

        expect(products[0].capacity).to eql 4
        expect(products[0].description).to eql "The low-cost Uber"
        expect(products[0].display_name).to eql "uberX"
        expect(products[0].product_id).to eql "a1111c8c-c720-46c3-8534-2fcdd730040d"
        expect(products[0].image).to eql "http://d1a3f4spazzrp4.cloudfront.net/car.jpg"
        expect(products[0].price_details.class).to be Hash
        expect(products[0].shared).to be true
        expect(products[0].cash_enabled).to be true
        expect(products[0].shared?).to be true
        expect(products[0].cash_enabled?).to be true

        expect(products[1].capacity).to eql 6
        expect(products[1].description).to eql "low-cost rides for large groups"
        expect(products[1].display_name).to eql "uberXL"
        expect(products[1].product_id).to eql "821415d8-3bd5-4e27-9604-194e4359a449"
        expect(products[1].image).to eql "http://d1a3f4spazzrp4.cloudfront.net/car.jpg"
        expect(products[1].price_details.class).to be Hash
        expect(products[1].shared).to be true
        expect(products[1].cash_enabled).to be true

        expect(products[2].capacity).to eql 4
        expect(products[2].description).to eql "The original Uber"
        expect(products[2].display_name).to eql "UberBLACK"
        expect(products[2].product_id).to eql "d4abaae7-f4d6-4152-91cc-77523e8165a4"
        expect(products[2].image).to eql "http://d1a3f4spazzrp4.cloudfront.net/car.jpg"
        expect(products[2].price_details.class).to be Hash
        expect(products[2].shared).to be false
        expect(products[2].cash_enabled).to be true

        expect(products[3].capacity).to eql 6
        expect(products[3].description).to eql "Room for everyone"
        expect(products[3].display_name).to eql "UberSUV"
        expect(products[3].product_id).to eql "8920cb5e-51a4-4fa4-acdf-dd86c5e18ae0"
        expect(products[3].image).to eql "http://d1a3f4spazzrp4.cloudfront.net/car.jpg"
        expect(products[3].price_details.class).to be Hash
        expect(products[3].shared).to be true
        expect(products[3].cash_enabled).to be false

        expect(products[4].capacity).to eql 4
        expect(products[4].description).to eql "Taxi without the hassle"
        expect(products[4].display_name).to eql "uberTAXI"
        expect(products[4].product_id).to eql "3ab64887-4842-4c8e-9780-ccecd3a0391d"
        expect(products[4].image).to eql "http://d1a3f4spazzrp4.cloudfront.net/car.jpg"
        expect(products[4].price_details).to be nil
        expect(products[4].shared).to be false
        expect(products[4].cash_enabled).to be false
        expect(products[4].shared?).to be false
        expect(products[4].cash_enabled?).to be false
      end
    end
  end

  describe '#apply_surge' do
    let!(:sandbox_client) { setup_client(sandbox: true) }

    before do
      stub_uber_request(:put, "v1/sandbox/products/deadbeef",
                        # From: https://developer.uber.com/docs/v1-requests-cancel
                        nil,
                        body: {surge_multiplier: 2.0},
                        status_code: 204,
                                     sandbox: true)
    end

    it 'should update the surge of the product in the sandbox' do
      request = sandbox_client.apply_surge('deadbeef', 2.0)
      expect(request.class).to eql Uber::Product
    end
  end

  describe '#apply_availability' do
    let!(:sandbox_client) { setup_client(sandbox: true) }

    before do
      stub_uber_request(:put, "v1/sandbox/products/deadbeef",
                        # From: https://developer.uber.com/docs/v1-requests-cancel
                        nil,
                        body: {drivers_available: false},
                        status_code: 204,
                                     sandbox: true)
    end

    it 'should update the drivers availability of the product in the sandbox' do
      request = sandbox_client.apply_availability('deadbeef', false)
      expect(request.class).to eql Uber::Product
    end
  end
end

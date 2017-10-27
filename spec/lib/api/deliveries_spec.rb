require 'spec_helper'
require 'uber'

describe Uber::API::Deliveries do
  let!(:client) { setup_client }

  describe 'on requesting deliveries' do
    before do
      stub_uber_request(:get, 'v1/deliveries',
                        {
                          "count" => 172,
                          "next_page" => "status=completed&limit=10&offset=10",
                          "previous_page" => "",
                          "deliveries" => [
                            {"courier"=>
                               {"location"=>
                                  {"latitude"=>40.7619629893, "longitude"=>-74.0014480227, "bearing"=>33},
                                "name"=>"Rob",
                                "phone"=>"+18622564699",
                                "picture_url"=>
                                  "https://d297l2q4lq2ras.cloudfront.net/nomad/2014/10/16/18/479x479_id_dba13493-27db-4d39-a322-8cb5eca67b54.jpeg",
                                "vehicle"=>
                                  {"license_plate"=>"RUSHNYC",
                                   "make"=>"Acura",
                                   "model"=>"ZDX",
                                   "picture_url"=>nil}},
                             "created_at"=>1441147296,
                             "currency_code"=>"USD",
                             "delivery_id"=>"8b58bc58-7352-4278-b569-b5d24d8e3f76",
                             "dropoff"=>
                               {"contact"=>
                                  {"company_name"=>"Gizmo Shop",
                                   "email"=>"contact@uber.com",
                                   "first_name"=>"Calvin",
                                   "last_name"=>"Lee",
                                   "phone"=>{"number"=>"+14081234567", "sms_enabled"=>false},
                                   "send_email_notifications"=>true,
                                   "send_sms_notifications"=>true},
                                "eta"=>30,
                                "location"=>
                                  {"address"=>"530 W 113th Street",
                                   "address_2"=>"Floor 2",
                                   "city"=>"New York",
                                   "country"=>"US",
                                   "postal_code"=>"10025",
                                   "state"=>"NY"},
                                "signature_required"=>false,
                                "special_instructions"=>nil},
                             "fee"=>5.0,
                             "items"=>
                               [{"height"=>5,
                                 "is_fragile"=>false,
                                 "length"=>14.5,
                                 "price"=>1,
                                 "quantity"=>1,
                                 "title"=>"Shoes",
                                 "weight"=>2,
                                 "width"=>7},
                                {"height"=>5,
                                 "is_fragile"=>false,
                                 "length"=>25,
                                 "quantity"=>1,
                                 "title"=>"Guitar",
                                 "weight"=>10,
                                 "width"=>12}],
                             "order_reference_id"=>"SDA124KA",
                             "pickup"=>
                               {"contact"=>
                                  {"company_name"=>"Gizmo Shop",
                                   "email"=>"contact@uber.com",
                                   "first_name"=>"Calvin",
                                   "last_name"=>"Lee",
                                   "phone"=>{"number"=>"+14081234567", "sms_enabled"=>false},
                                   "send_email_notifications"=>true,
                                   "send_sms_notifications"=>true},
                                "eta"=>4,
                                "location"=>
                                  {"address"=>"636 W 28th Street",
                                   "address_2"=>"Floor 2",
                                   "city"=>"New York",
                                   "country"=>"US",
                                   "postal_code"=>"10001",
                                   "state"=>"NY"},
                                "special_instructions"=>"Go to pickup counter in back of shop."},
                             "quote_id"=>
                               "KEBiNmI4MWQ0NDIzNjUyNjE1ZmM5YzlkNDQ5NDA4MzhlNTg5MWZlNzQ5YTNmZTRkYzQxZTgxMzc4YjlkZjU0Yjc2Fbamsd4KFeavsd4KFYD1sgwcFdD/0oQDFYfw48EFABwVyoCThQMVp/qvwQUAGANVU0QA",
                             "status"=>"en_route_to_pickup",
                             "tracking_url"=>"https://trip.uber.com/v2/share/-JazZXXuBl",
                             "batch"=>
                               {"batch_id"=>"963233d3-e8ad-4ed9-aae7-95446ffee22f",
                                "count"=>2,
                                "deliveries"=>
                                  ["8b58bc58-7352-4278-b569-b5d24d8e3f76",
                                   "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"]}
                            }
                          ]
                        }
      )
    end
    it 'should return list of all deliveries' do
      deliveries = client.deliveries
      expect(deliveries.size).to eql 1

      expect(deliveries[0].courier.class).to eql Hash
      expect(deliveries[0].created_at).to eql ::Time.at(1441147296)
      expect(deliveries[0].currency_code).to eql 'USD'
      expect(deliveries[0].delivery_id).to eql '8b58bc58-7352-4278-b569-b5d24d8e3f76'
      expect(deliveries[0].dropoff.class).to eql Hash
      expect(deliveries[0].fee).to eql 5.0
      expect(deliveries[0].items.class).to eql Array
      expect(deliveries[0].order_reference_id).to eql 'SDA124KA'
      expect(deliveries[0].pickup.class).to eql Hash
      expect(deliveries[0].quote_id).to eql 'KEBiNmI4MWQ0NDIzNjUyNjE1ZmM5YzlkNDQ5NDA4MzhlNTg5MWZlNzQ5YTNmZTRkYzQxZTgxMzc4YjlkZjU0Yjc2Fbamsd4KFeavsd4KFYD1sgwcFdD/0oQDFYfw48EFABwVyoCThQMVp/qvwQUAGANVU0QA'
      expect(deliveries[0].status).to eql 'en_route_to_pickup'
      expect(deliveries[0].tracking_url).to eql 'https://trip.uber.com/v2/share/-JazZXXuBl'
      expect(deliveries[0].batch.class).to eql Hash
    end
  end

  describe 'on requesting a particular delivery' do
    before do
      stub_uber_request(:get, "v1/deliveries/8b58bc58-7352-4278-b569-b5d24d8e3f76",
                        {
                          "courier"=>
                           {"location"=>
                              {"latitude"=>40.7619629893, "longitude"=>-74.0014480227, "bearing"=>33},
                            "name"=>"Rob",
                            "phone"=>"+18622564699",
                            "picture_url"=>
                              "https://d297l2q4lq2ras.cloudfront.net/nomad/2014/10/16/18/479x479_id_dba13493-27db-4d39-a322-8cb5eca67b54.jpeg",
                            "vehicle"=>
                              {"license_plate"=>"RUSHNYC",
                               "make"=>"Acura",
                               "model"=>"ZDX",
                               "picture_url"=>nil}},
                         "created_at"=>1441147296,
                         "currency_code"=>"USD",
                         "delivery_id"=>"8b58bc58-7352-4278-b569-b5d24d8e3f76",
                         "dropoff"=>
                           {"contact"=>
                              {"company_name"=>"Gizmo Shop",
                               "email"=>"contact@uber.com",
                               "first_name"=>"Calvin",
                               "last_name"=>"Lee",
                               "phone"=>{"number"=>"+14081234567", "sms_enabled"=>false},
                               "send_email_notifications"=>true,
                               "send_sms_notifications"=>true},
                            "eta"=>30,
                            "location"=>
                              {"address"=>"530 W 113th Street",
                               "address_2"=>"Floor 2",
                               "city"=>"New York",
                               "country"=>"US",
                               "postal_code"=>"10025",
                               "state"=>"NY"},
                            "signature_required"=>false,
                            "special_instructions"=>nil},
                         "fee"=>5.0,
                         "items"=>
                           [{"height"=>5,
                             "is_fragile"=>false,
                             "length"=>14.5,
                             "price"=>1,
                             "quantity"=>1,
                             "title"=>"Shoes",
                             "weight"=>2,
                             "width"=>7},
                            {"height"=>5,
                             "is_fragile"=>false,
                             "length"=>25,
                             "quantity"=>1,
                             "title"=>"Guitar",
                             "weight"=>10,
                             "width"=>12}],
                         "order_reference_id"=>"SDA124KA",
                         "pickup"=>
                           {"contact"=>
                              {"company_name"=>"Gizmo Shop",
                               "email"=>"contact@uber.com",
                               "first_name"=>"Calvin",
                               "last_name"=>"Lee",
                               "phone"=>{"number"=>"+14081234567", "sms_enabled"=>false},
                               "send_email_notifications"=>true,
                               "send_sms_notifications"=>true},
                            "eta"=>4,
                            "location"=>
                              {"address"=>"636 W 28th Street",
                               "address_2"=>"Floor 2",
                               "city"=>"New York",
                               "country"=>"US",
                               "postal_code"=>"10001",
                               "state"=>"NY"},
                            "special_instructions"=>"Go to pickup counter in back of shop."},
                         "quote_id"=>
                           "KEBiNmI4MWQ0NDIzNjUyNjE1ZmM5YzlkNDQ5NDA4MzhlNTg5MWZlNzQ5YTNmZTRkYzQxZTgxMzc4YjlkZjU0Yjc2Fbamsd4KFeavsd4KFYD1sgwcFdD/0oQDFYfw48EFABwVyoCThQMVp/qvwQUAGANVU0QA",
                         "status"=>"en_route_to_pickup",
                         "tracking_url"=>"https://trip.uber.com/v2/share/-JazZXXuBl",
                         "batch"=>
                           {"batch_id"=>"963233d3-e8ad-4ed9-aae7-95446ffee22f",
                            "count"=>2,
                            "deliveries"=>
                              ["8b58bc58-7352-4278-b569-b5d24d8e3f76",
                               "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"]}
                        })
    end

    it 'should give detail about that delivery' do
      delivery = client.delivery("8b58bc58-7352-4278-b569-b5d24d8e3f76")

      expect(delivery.courier.class).to eql Hash
      expect(delivery.created_at).to eql ::Time.at(1441147296)
      expect(delivery.currency_code).to eql 'USD'
      expect(delivery.delivery_id).to eql '8b58bc58-7352-4278-b569-b5d24d8e3f76'
      expect(delivery.dropoff.class).to eql Hash
      expect(delivery.fee).to eql 5.0
      expect(delivery.items.class).to eql Array
      expect(delivery.order_reference_id).to eql 'SDA124KA'
      expect(delivery.pickup.class).to eql Hash
      expect(delivery.quote_id).to eql 'KEBiNmI4MWQ0NDIzNjUyNjE1ZmM5YzlkNDQ5NDA4MzhlNTg5MWZlNzQ5YTNmZTRkYzQxZTgxMzc4YjlkZjU0Yjc2Fbamsd4KFeavsd4KFYD1sgwcFdD/0oQDFYfw48EFABwVyoCThQMVp/qvwQUAGANVU0QA'
      expect(delivery.status).to eql 'en_route_to_pickup'
      expect(delivery.tracking_url).to eql 'https://trip.uber.com/v2/share/-JazZXXuBl'
      expect(delivery.batch.class).to eql Hash
    end
  end

end

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
      deliveries = client.deliveries.list
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
      delivery = client.deliveries.retrieve("8b58bc58-7352-4278-b569-b5d24d8e3f76")

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

  describe 'on creating a delivery' do
    before do
      stub_uber_request(:post, "v1/deliveries",
                        {"courier"=>nil,
                         "created_at"=>1441146983,
                         "currency_code"=>"USD",
                         "delivery_id"=>"b32d5374-7cee-4bc0-b588-f3820ab9b98c",
                         "dropoff"=>
                           {"contact"=>
                              {"company_name"=>"Gizmo Shop",
                               "email"=>"contact@uber.com",
                               "first_name"=>"Calvin",
                               "last_name"=>"Lee",
                               "phone"=>{"number"=>"+14081234567", "sms_enabled"=>false},
                               "send_email_notifications"=>true,
                               "send_sms_notifications"=>true},
                            "eta"=>20,
                            "location"=>
                              {"address"=>"530 W 113th Street",
                               "address_2"=>"Floor 2",
                               "city"=>"New York",
                               "country"=>"US",
                               "postal_code"=>"10025",
                               "state"=>"NY"},
                            "signature_required"=>false,
                            "special_instructions"=>nil},
                         "fee"=>5,
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
                            "eta"=>5,
                            "location"=>
                              {"address"=>"636 W 28th Street",
                               "address_2"=>"Floor 2",
                               "city"=>"New York",
                               "country"=>"US",
                               "postal_code"=>"10001",
                               "state"=>"NY"},
                            "special_instructions"=>"Go to pickup counter in back of shop."},
                         "quote_id"=>
                           "KEBjNGUxNjhlZmNmMDA4ZGJjNmJlY2EwOGJlN2M0ZjdmZjI2Y2VkZDdmMmQ2MDJlZDJjMTc4MzM2ODU2YzRkMzU4FYihsd4KFbiqsd4KFYD1sgwcFdD/0oQDFYfw48EFABwVyoCThQMVp/qvwQUAGANVU0QA",
                         "status"=>"processing",
                         "tracking_url"=>nil,
                         "batch"=>
                           {"batch_id"=>"963233d3-e8ad-4ed9-aae7-95446ffee22f",
                            "count"=>2,
                            "deliveries"=>
                              ["8b58bc58-7352-4278-b569-b5d24d8e3f76",
                               "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"]}
                        },
                        body: {
                               "dropoff"=>
                                 {"contact"=>
                                    {"company_name"=>"Gizmo Shop",
                                     "email"=>"contact@uber.com",
                                     "first_name"=>"Calvin",
                                     "last_name"=>"Lee",
                                     "phone"=>{"number"=>"+14081234567", "sms_enabled"=>false},
                                     "send_email_notifications"=>true,
                                     "send_sms_notifications"=>true},
                                  "eta"=>20,
                                  "location"=>
                                    {"address"=>"530 W 113th Street",
                                     "address_2"=>"Floor 2",
                                     "city"=>"New York",
                                     "country"=>"US",
                                     "postal_code"=>"10025",
                                     "state"=>"NY"},
                                  "signature_required"=>false,
                                  "special_instructions"=>nil},
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
                                  "location"=>
                                    {"address"=>"636 W 28th Street",
                                     "address_2"=>"Floor 2",
                                     "city"=>"New York",
                                     "country"=>"US",
                                     "postal_code"=>"10001",
                                     "state"=>"NY"},
                                  "special_instructions"=>"Go to pickup counter in back of shop."},
                               "quote_id"=>
                                 "KEBjNGUxNjhlZmNmMDA4ZGJjNmJlY2EwOGJlN2M0ZjdmZjI2Y2VkZDdmMmQ2MDJlZDJjMTc4MzM2ODU2YzRkMzU4FYihsd4KFbiqsd4KFYD1sgwcFdD/0oQDFYfw48EFABwVyoCThQMVp/qvwQUAGANVU0QA"
                        }.to_json,
                        status_code: 200
      )
    end
    it 'should return newly created delivery' do
      delivery = client.deliveries.add_delivery({
                                       "dropoff"=>
                                         {"contact"=>
                                            {"company_name"=>"Gizmo Shop",
                                             "email"=>"contact@uber.com",
                                             "first_name"=>"Calvin",
                                             "last_name"=>"Lee",
                                             "phone"=>{"number"=>"+14081234567", "sms_enabled"=>false},
                                             "send_email_notifications"=>true,
                                             "send_sms_notifications"=>true},
                                          "eta"=>20,
                                          "location"=>
                                            {"address"=>"530 W 113th Street",
                                             "address_2"=>"Floor 2",
                                             "city"=>"New York",
                                             "country"=>"US",
                                             "postal_code"=>"10025",
                                             "state"=>"NY"},
                                          "signature_required"=>false,
                                          "special_instructions"=>nil},
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
                                          "location"=>
                                            {"address"=>"636 W 28th Street",
                                             "address_2"=>"Floor 2",
                                             "city"=>"New York",
                                             "country"=>"US",
                                             "postal_code"=>"10001",
                                             "state"=>"NY"},
                                          "special_instructions"=>"Go to pickup counter in back of shop."},
                                       "quote_id"=>
                                         "KEBjNGUxNjhlZmNmMDA4ZGJjNmJlY2EwOGJlN2M0ZjdmZjI2Y2VkZDdmMmQ2MDJlZDJjMTc4MzM2ODU2YzRkMzU4FYihsd4KFbiqsd4KFYD1sgwcFdD/0oQDFYfw48EFABwVyoCThQMVp/qvwQUAGANVU0QA"
                                     })
      expect(delivery.delivery_id).to eql "b32d5374-7cee-4bc0-b588-f3820ab9b98c"
    end
  end

  describe 'on adding quote' do
    before do
      stub_uber_request(:post, 'v1/deliveries/quote',
                        {"quotes"=>
                           [{"quote_id"=>
                               "CwACAAAAQGU0NTYwYjUyNjY4YzBjNDBiNDFjYzA4ZDdlNzE0OWM3ZmYxZjY0NTJkNDQ1NjE2NDg3NDI1ZmFkZjZiYTI1ODcIAANXHm3xCAAEVx5wSQgABQBSs-AMAAYIAAEYXJdJCAAC0_FrQwAMAAcIAAEYWt-7CAAC0_BeNAALAAgAAAADVVNEAA==",
                             "estimated_at"=>1461612017,
                             "expires_at"=>1461612617,
                             "fee"=>5.42,
                             "currency_code"=>"USD",
                             "pickup_eta"=>6,
                             "dropoff_eta"=>13},
                            {"quote_id"=>
                               "CwACAAAAQDNkMWZhMDg0ZWJiNzkwMTA4MGNmNzlkMTdlN2U1MGE2YzI1NTQ0Yzc4ZmIwOTIyNzUwMDc0ZDNjNGFhZjRlYjMIAANXHm3xCAAEVx5wSQgABQBCOSAMAAYIAAEYXJdJCAAC0_FrQwAMAAcIAAEYWt-7CAAC0_BeNAALAAgAAAADVVNECgAJAAABVE84wIAKAAoAAAFUT2-vAAoACwAAAVRPLXXgAA==",
                             "estimated_at"=>1461612017,
                             "expires_at"=>1461612617,
                             "start_time"=>1461618000,
                             "end_time"=>1461621600,
                             "fee"=>4.34,
                             "currency_code"=>"USD",
                             "ready_by_time"=>1461617260},
                            {"quote_id"=>
                               "CwACAAAAQGViOWFkM2E5NTBkZDlmOWI1NjI4ODc0NTljMjc3OWFlZWY1YmVkODVhMzc4MGQ4N2RlNTI3NDAzNWU3NTIxYzUIAANXHm3xCAAEVx5wSQgABQBCOSAMAAYIAAEYXJdJCAAC0_FrQwAMAAcIAAEYWt-7CAAC0_BeNAALAAgAAAADVVNECgAJAAABVE9vrwAKAAoAAAFUT6adgAoACwAAAVRPZGRgAA==",
                             "estimated_at"=>1461612017,
                             "expires_at"=>1461612617,
                             "start_time"=>1461621600,
                             "end_time"=>1461625200,
                             "fee"=>4.34,
                             "currency_code"=>"USD",
                             "ready_by_time"=>1461620860},
                            {"quote_id"=>
                               "CwACAAAAQDljOGJkZmVjZjg0NDgwNGJhY2UyNDAzYTU4NjA3OTc5MjA3NmIxMmJmMjNhOTM3YWQ0NGM3NGMwYzNjNTM4OTQIAANXHm3xCAAEVx5wSQgABQBCOSAMAAYIAAEYXJdJCAAC0_FrQwAMAAcIAAEYWt-7CAAC0_BeNAALAAgAAAADVVNECgAJAAABVE-mnYAKAAoAAAFUT92MAAoACwAAAVRPm1LgAA==",
                             "estimated_at"=>1461612017,
                             "expires_at"=>1461612617,
                             "start_time"=>1461625200,
                             "end_time"=>1461628800,
                             "fee"=>4.34,
                             "currency_code"=>"USD",
                             "ready_by_time"=>1461624460}]
                        },
                        body: {
                          "pickup" => {
                            "location" => {
                              "address"=>"636 W 28th Street",
                              "address_2"=>"Floor 2",
                              "city"=>"New York",
                              "country"=>"US",
                              "postal_code"=>"10001",
                              "state"=>"NY"
                            }
                          },
                          "dropoff" => {
                            "location" => {
                              "address"=>"530 W 113th Street",
                              "address_2"=>"Floor 2",
                              "city"=>"New York",
                              "country"=>"US",
                              "postal_code"=>"10025",
                              "state"=>"NY"
                            }
                          }
                        }.to_json,
                        status_code: 201
      )
    end

    it 'should return on-demand and scheduled delivery quotes' do
      quotes = client.deliveries.add_quote({
                                            "pickup" => {
                                              "location" => {
                                                "address"=>"636 W 28th Street",
                                                "address_2"=>"Floor 2",
                                                "city"=>"New York",
                                                "country"=>"US",
                                                "postal_code"=>"10001",
                                                "state"=>"NY"
                                              }
                                            },
                                            "dropoff" => {
                                              "location" => {
                                                "address"=>"530 W 113th Street",
                                                "address_2"=>"Floor 2",
                                                "city"=>"New York",
                                                "country"=>"US",
                                                "postal_code"=>"10025",
                                                "state"=>"NY"
                                              }
                                            }
                                          })
      expect(quotes.size).to eql 4

      expect(quotes[0].quote_id).to eql 'CwACAAAAQGU0NTYwYjUyNjY4YzBjNDBiNDFjYzA4ZDdlNzE0OWM3ZmYxZjY0NTJkNDQ1NjE2NDg3NDI1ZmFkZjZiYTI1ODcIAANXHm3xCAAEVx5wSQgABQBSs-AMAAYIAAEYXJdJCAAC0_FrQwAMAAcIAAEYWt-7CAAC0_BeNAALAAgAAAADVVNEAA=='
      expect(quotes[0].estimated_at).to eql Time.at(1461612017)
      expect(quotes[0].expires_at).to eql Time.at(1461612617)
      expect(quotes[0].fee).to eql 5.42
      expect(quotes[0].currency_code).to eql 'USD'
      expect(quotes[0].pickup_eta).to eql 6
      expect(quotes[0].dropoff_eta).to eql 13
    end
  end

  describe 'on requesting receipt' do
    before do
      stub_uber_request(:get, 'v1/deliveries/78aa3783-e845-4a85-910c-be30dd0c712b/receipt',
                        {"charges"=>[{"amount"=>9.79, "name"=>"Trip fare"}],
                         "charge_adjustments"=>
                           [{"amount"=>-1, "name"=>"Uber Credit"},
                            {"amount"=>-2.62, "name"=>"Batch Discount"}],
                         "delivery_id"=>"78aa3783-e845-4a85-910c-be30dd0c712b",
                         "currency_code"=>"USD",
                         "total_fee"=>6.17})
    end
    it 'should return delivery receipt with details' do
      receipt = client.deliveries.receipt('78aa3783-e845-4a85-910c-be30dd0c712b')
      expect(receipt.charges.class).to eql Array
      expect(receipt.charge_adjustments.class).to eql Array
      expect(receipt.delivery_id).to eql '78aa3783-e845-4a85-910c-be30dd0c712b'
      expect(receipt.currency_code).to eql 'USD'
      expect(receipt.total_fee).to eql 6.17
    end
  end

  describe 'on requesting ratings of a delivery' do
    before do
      stub_uber_request(:get, 'v1/deliveries/8b58bc58-7352-4278-b569-b5d24d8e3f76/ratings',
                        {"ratings"=>
                           [{"waypoint"=>"pickup",
                             "rating_type"=>"binary",
                             "rating_value"=>0,
                             "tags"=>["courier_unprofessional", "courier_remained_at_curbside"],
                             "comments"=>"Courier was not professionally dressed."},
                            {"waypoint"=>"dropoff",
                             "rating_type"=>"binary",
                             "rating_value"=>0,
                             "tags"=>["courier_not_on_time", "delivery_in_good_condition"],
                             "comments"=>"Courier was not professionally dressed."}]
                        })
    end
    it 'should return all avilable ratings for that delivery' do
      ratings = client.deliveries.ratings('8b58bc58-7352-4278-b569-b5d24d8e3f76')

      expect(ratings.size).to eql 2
      expect(ratings[0].waypoint).to eql 'pickup'
      expect(ratings[0].rating_type).to eql 'binary'
      expect(ratings[0].rating_value).to eql 0
      expect(ratings[0].tags).to eql ["courier_unprofessional", "courier_remained_at_curbside"]
      expect(ratings[0].comments).to eql 'Courier was not professionally dressed.'
    end
  end

  describe 'on adding a rating to a delivery' do
    before do
      stub_uber_request(:post, 'v1/deliveries/8b58bc58-7352-4278-b569-b5d24d8e3f76/rating',
                        nil,
                        body: {"waypoint"=>"dropoff",
                               "rating_type"=>"binary",
                               "rating_value"=>0,
                               "tags"=>["courier_not_on_time", "delivery_in_good_condition"],
                               "comments"=>"Courier was not professionally dressed."}.to_json,
                        status_code: 204
      )
    end

    it 'should create rating and return nothing' do
      status = client.deliveries.add_rating('8b58bc58-7352-4278-b569-b5d24d8e3f76',
                                          {"waypoint"=>"dropoff",
                                           "rating_type"=>"binary",
                                           "rating_value"=>0,
                                           "tags"=>["courier_not_on_time", "delivery_in_good_condition"],
                                           "comments"=>"Courier was not professionally dressed."})
      expect(status).to eql 204
    end
  end

  describe 'on request delivery rating tags' do
    before do
      stub_uber_request(:get, 'v1/deliveries/8b58bc58-7352-4278-b569-b5d24d8e3f76/rating_tags',
                        {"rating_tags"=>
                           [{"waypoint"=>"pickup",
                             "tags"=>
                               ["courier_remained_at_curbside",
                                "courier_missing_delivery_bag",
                                "courier_unprofessional",
                                "courier_late_to_pickup",
                                "courier_late_to_dropoff",
                                "inaccurate_eta",
                                "courier_missed_pickup_instructions"]},
                            {"waypoint"=>"dropoff",
                             "tags"=>
                               ["courier_on_time",
                                "courier_not_on_time",
                                "delivery_in_good_condition",
                                "delivery_in_bad_condition",
                                "courier_good_service",
                                "courier_bad_service"]}]
                        })
    end
    it 'should return all available rating tags for the delivery' do
      tags = client.deliveries.rating_tags('8b58bc58-7352-4278-b569-b5d24d8e3f76')

      expect(tags.size).to eql 2
      expect(tags[0].waypoint).to eql 'pickup'
      expect(tags[0].tags.class).to eql Array
      expect(tags[0].tags).to eql  ["courier_remained_at_curbside", "courier_missing_delivery_bag",
                                     "courier_unprofessional", "courier_late_to_pickup",
                                     "courier_late_to_dropoff", "inaccurate_eta",
                                     "courier_missed_pickup_instructions"]
    end
  end

  describe 'on canceling the delivery' do
    before do
      stub_uber_request(:post, 'v1/deliveries/8b58bc58-7352-4278-b569-b5d24d8e3f76/cancel', nil,
                        body: {}.to_json, status_code: 204)
    end
    it 'should cancel the delivery request and return status code' do
      status = client.deliveries.cancel('8b58bc58-7352-4278-b569-b5d24d8e3f76')
      expect(status).to eql 204
    end
  end

  describe 'on requesting regions' do
    before do
      stub_uber_request(:get, 'v1/deliveries/regions',
                        {"regions"=>
                           [{"city"=>"San Francisco",
                             "country"=>"USA",
                             "type"=>"FeatureCollection",
                             "features"=>
                               [{"type"=>"Feature",
                                 "properties"=>{},
                                 "geometry"=>
                                   {"type"=>"Polygon",
                                    "coordinates"=>
                                      [[[-122.52330780029295, 37.80815648152641],
                                        [-122.38357543945312, 37.81385247479046],
                                        [-122.33379364013672, 37.69197100839692],
                                        [-122.50888824462889, 37.67920120945425],
                                        [-122.52330780029295, 37.80815648152641]]]}}
                               ]
                            }]
                        })
    end
    it 'should return all regions where UberRUSH is available' do
      regions = client.deliveries.regions
      expect(regions.size).to eql 1
      expect(regions[0].city).to eql 'San Francisco'
      expect(regions[0].country).to eql 'USA'
      expect(regions[0].type).to eql 'FeatureCollection'
      expect(regions[0].features.class).to eql Array
    end
  end
end

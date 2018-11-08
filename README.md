
# The Uber Ruby Gem

![travis AnkurGel](https://travis-ci.org/AnkurGel/uber-ruby.svg?branch=master)

> A Ruby interface to the Uber API.


## Installation

Add this line to your application's Gemfile:

    gem 'uber-ruby', require: 'uber'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install uber-ruby

## Configuration

```ruby
client = Uber::Client.new do |config|
  config.server_token  = "YOUR_SERVER_TOKEN"
  config.client_id     = "YOUR_CLIENT_ID"
  config.client_secret = "YOUR_CLIENT_SECRET"
end
```

### Sandbox mode
The Uber API Sandbox provides development endpoints for testing the functionality of an application without making calls to the production Uber platform. All requests made to the Sandbox environment will be ephemeral.

```ruby
client = Uber::Client.new do |config|
  config.server_token  = "YOUR_SERVER_TOKEN"
  config.client_id     = "YOUR_CLIENT_ID"
  config.client_secret = "YOUR_CLIENT_SECRET"
  config.sandbox       = true
end
# More info here https://developer.uber.com/docs/sandbox#section-product-types
```

## Debug mode
Add `config.debug = true` to log HTTP request-response headers while making API requests.

## Usage

### Request Products

```ruby
client = Uber::Client.new do |config|
  config.server_token  = "YOUR_SERVER_TOKEN"
end
client.products(latitude: lat, longitude: lon)
```

### Request price estimations

```ruby
client = Uber::Client.new do |config|
  config.server_token  = "YOUR_SERVER_TOKEN"
end
client.price_estimations(start_latitude: slat, start_longitude: slon,
                         end_latitude: dlat, end_longitude: dlon)
```

### Request time estimations

```ruby
client = Uber::Client.new do |config|
  config.server_token  = "YOUR_SERVER_TOKEN"
end
client.time_estimations(start_latitude: slat, start_longitude: slon)
```

### Retrieve user info

```ruby
client = Uber::Client.new do |config|
  config.server_token  = "YOUR_SERVER_TOKEN"
  config.client_id     = "YOUR_CLIENT_ID"
  config.client_secret = "YOUR_CLIENT_SECRET"
  config.bearer_token  = "USER_ACCESS_TOKEN"
end
client.me
```

### Retrieve user activities

```ruby
client = Uber::Client.new do |config|
  config.server_token  = "YOUR_SERVER_TOKEN"
  config.client_id     = "YOUR_CLIENT_ID"
  config.client_secret = "YOUR_CLIENT_SECRET"
  config.bearer_token  = "USER_ACCESS_TOKEN"
end
client.history
```

### Request a ride

```ruby
client = Uber::Client.new do |config|
  config.client_id     = "YOUR_CLIENT_ID"
  config.client_secret = "YOUR_CLIENT_SECRET"
  config.bearer_token  = "USER_ACCESS_TOKEN"
end

client.trip_request(product_id: product_id, start_latitude: start_lat, start_longitude: start_lng, end_latitude: end_lat, end_longitude: end_lng)
```

### Simulate a ride request with surge

```ruby
client = Uber::Client.new do |config|
  config.client_id     = "YOUR_CLIENT_ID"
  config.client_secret = "YOUR_CLIENT_SECRET"
  config.bearer_token  = "USER_ACCESS_TOKEN"
end

# Only available in sandbox environment
# Use this to simulate a surge
# More info here https://developer.uber.com/docs/sandbox#section-product-types
client.apply_surge 'product_id', 2.0

client.trip_request(product_id: product_id, start_latitude: start_lat, start_longitude: start_lng, end_latitude: end_lat, end_longitude: end_lng, surge_confirmation_id: surge_id)
```

### Simulate a ride request with no drivers available

```ruby
client = Uber::Client.new do |config|
  config.client_id     = "YOUR_CLIENT_ID"
  config.client_secret = "YOUR_CLIENT_SECRET"
  config.bearer_token  = "USER_ACCESS_TOKEN"
end

# Only available in sandbox environment
# Use this to simulate a request with no drivers available
# More info here https://developer.uber.com/docs/sandbox#section-product-types
client.apply_availability 'product_id', false

client.trip_request(product_id: product_id, start_latitude: start_lat, start_longitude: start_lng, end_latitude: end_lat, end_longitude: end_lng)
```

### Update the status of a ride request

```ruby
client = Uber::Client.new do |config|
  config.client_id     = "YOUR_CLIENT_ID"
  config.client_secret = "YOUR_CLIENT_SECRET"
  config.bearer_token  = "USER_ACCESS_TOKEN"
end

# Only available in sandbox environment
# Use this to simulate the status change of a ride request
# More info here https://developer.uber.com/docs/sandbox#section-request

client.trip_update('request_id', 'accepted')
```

### Retrieve a ride request details

```ruby
client = Uber::Client.new do |config|
  config.client_id     = "YOUR_CLIENT_ID"
  config.client_secret = "YOUR_CLIENT_SECRET"
  config.bearer_token  = "USER_ACCESS_TOKEN"
end

client.trip_details 'request_id'
```

### Cancel a ride request

```ruby
client = Uber::Client.new do |config|
  config.client_id     = "YOUR_CLIENT_ID"
  config.client_secret = "YOUR_CLIENT_SECRET"
  config.bearer_token  = "USER_ACCESS_TOKEN"
end

client.trip_cancel 'request_id'
```

### Generate ride receipt
Generates the receipt for a completed request.

```ruby
client = Uber::Client.new do |config|
  config.client_id     = "YOUR_CLIENT_ID"
  config.client_secret = "YOUR_CLIENT_SECRET"
  config.bearer_token  = "USER_ACCESS_TOKEN"
end

client.trip_receipt 'request_id' #=> Generates Uber::Receipt
# or
receipt = client.ride_receipt 'request_id'
receipt.total_charged #=> "$5.92"
```

### Retrieve addresses
Retrieves address information of _home_ or _work_.

```ruby
client = Uber::Client.new do |config|
  config.client_id     = "YOUR_CLIENT_ID"
  config.client_secret = "YOUR_CLIENT_SECRET"
  config.bearer_token  = "USER_ACCESS_TOKEN"
end

place = client.place 'home'
place.address #=> returns fully qualified address of location
```

### Update addresses
Updates address information of _home_ or _work_.
```ruby
client = Uber::Client.new do |config|
  config.client_id     = "YOUR_CLIENT_ID"
  config.client_secret = "YOUR_CLIENT_SECRET"
  config.bearer_token  = "USER_ACCESS_TOKEN"
end

place = client.place_update 'home', 'my address'
place.address #=> retuns fully qualified address of location
```

### Retrieve a reminder
This allows you to get the status of an existing ride reminder.    
**Note**: It only supports _server_token_. 
```ruby
client = Uber::Client.new do |config|
  config.client_id     = "YOUR_CLIENT_ID"
  config.client_secret = "YOUR_CLIENT_SECRET"
  client.server_token  = "YOUR_SERVER_TOKEN"
end
client.reminder 'reminder_id'
#=> Uber::Reminder
```

### Add a reminder
This allows developers to set a reminder for a future trip. You can pass object of `Time` or _unixtime_ in `reminder_time` and `event.time`.
```ruby
reminder = client.add_reminder({reminder_time: Time.local(2016, 9, 8, 23, 23, 23),
                                phone_number: '+91-9999999999',
                                trip_branding: {link_text: 'My first reminder'},
                                event: {time: Time.now + 234234},
                                reminder_id: 'rem1' })
reminder.event.time
#=> 2016-09-11 11:02:06 UTC
reminder.reminder_time
#=> 2016-09-08 17:53:23 UTC
reminder.reminder_status
#=> "pending"
```

### Update a reminder
This allows you to update an existing reminder.
```ruby
reminder = client.add_reminder('rem1', {reminder_time: Time.local(2016, 9, 10, 23, 23, 23),
                                        phone_number: '+91-9999999999',
                                        trip_branding: {link_text: 'My edited reminder'},
                                        event: {time: Time.now + 234234},
                                        reminder_id: 'rem1' })
reminder.trip_branding.link_text
#=> "My edited reminder"

```

### Delete a reminder
This allows you to remove any reminder in the pending state from being sent.
```ruby
reminder.delete_reminder 'rem1'
#=> Uber::Reminder
```

## Drivers API
[Drivers API](https://developer.uber.com/docs/drivers/introduction) lets you build services and solutions that make the driver experience more productive and rewarding. With the driver's permission, you can use trip data, earnings, ratings and more to shape the future of the on-demand economy.   

We provide this under namespace of `client.partners`

### Driver details
It returns the profile of the authenticated driver.
> OAuth 2.0 bearer token with a partner.accounts scope.   
 
```ruby
driver = client.partners.me
driver.first_name #=> 'John'
driver.last_name #=> 'Driver'
driver.promo_code #=> 'join_john_on_uber'
```
More details can be found [here](https://developer.uber.com/docs/drivers/references/api/v1.2/partners-me-get).

### Earnings details
It returns an array of payments for the given driver. Payments are available at this endpoint in near real-time.
> OAuth 2.0 bearer token with scope partner.payments

```ruby
earnings = client.partners.payments 
# client.partners.earnings is also supported
earnings.count #=> 5
earnings.payments #=> Array of Uber::Partner::Payment
payment = earnings.payments.first
payment.category #=> 'fare'
payment.cash_collected #=> 7.63
payment.currency_code #=> 'USD'
payment.event_time #=> 2016-11-12 10:29:28 UTC

# Using params:
earnings = client.partners.payments(:offset => 1, :limit => 2)
```
More details can be found [here](https://developer.uber.com/docs/drivers/references/api/v1.2/partners-payments-get).

### Trips details
It returns an array of trips for the authenticated driver.    
> OAuth 2.0 bearer token with the partner.trips.

```ruby
trips = client.partners.trips 
trips.count #=> 1
trips.offset #=> 0
trips.trips #=> Array of Uber::Partner::Trip
trip = trips.trips.first
trip.distance #=> 0
trip.status #=> 'driver_canceled'
trip.duration #=> 0
```
More details can be found [here](https://developer.uber.com/docs/drivers/references/api/v1.2/partners-trips-get).

## Deliveries API
[Deliveries API]() lets you and your customer track the exact location of your delivery from any device. 
> OAuth 2.0 bearer token with the delivery scope 

We provide this under namespace of `client.deliveries`. Besides OAuth, you can get bearer token with `delivery` scope via __client_credentials__ workflow, follow this [guide](https://developer.uber.com/docs/deliveries/guides/authentication#client-credentials-flow).

```ruby
client = Uber::Client.new do |config|
  config.server_token  = "YOUR_SERVER_TOKEN"
  config.client_id     = "YOUR_CLIENT_ID"
  config.client_secret = "YOUR_CLIENT_SECRET"
  config.bearer_token  = "USER_ACCESS_TOKEN"
end
```


### List deliveries
It retrieves a list of all deliveries
  

```ruby
deliveries = client.deliveries.list #=> Array of Uber::Delivery::Delivery
```
More details can be found [here](https://developer.uber.com/docs/deliveries/references/api/v1.2/deliveries-get)

### Create a delivery
It allows a delivery to be requested given the delivery information and quote ID

```ruby
delivery = client.deliveries.add_delivery({quote_id: 'KEBjNGUxNjhlZmNmMD...', .. })
delivery.quote_id #=> 'KEBjNGUxNjhlZmNmMD...'
```
More details and parameters can be found [here](https://developer.uber.com/docs/deliveries/references/api/v1.2/deliveries-post)

### Create delivery quote
Generate a delivery quote, given a pickup and dropoff location. On-demand and scheduled delivery quotes will be returned.

```ruby
quotes = client.deliveries.add_quote({ "pickup" => { "location" => { ... } }, 
                                       "dropoff" => { "location" => { ... } } )
# returns array of Uber::Delivery::Quote containing all On-demand and scheduled delivery quotes
quotes.size #=> 4
quotes[0].fee #=> 5.42
```
More details can be found [here](https://developer.uber.com/docs/deliveries/references/api/v1.2/deliveries-quote-post)

### Retrieve a delivery information
Get the status of an ongoing delivery

```ruby
delivery = client.deliveries.retrieve('8b58bc58-7352-4278-b569-b5d24d8e3f76') #=> Uber::Delivery::Delivery
delivery.currency_code #=> "USD"
delivery.delivery_id #=> '8b58bc58-7352-4278-b569-b5d24d8e3f76'
delivery.fee #=> 5.0
```
More details can be found [here](https://developer.uber.com/docs/deliveries/references/api/v1.2/deliveries-delivery_id-get)

### Retrieve receipt for a delivery
```ruby
receipt = client.deliveries.receipt('8b58bc58-7352-4278-b569-b5d24d8e3f76') #=> Uber::Delivery::Receipt
receipt.delivery_id #=> '8b58bc58-7352-4278-b569-b5d24d8e3f76'
receipt.total_fee #=> 6.17
receipt.charges #=> hash of charges
```
More details can be found [here](https://developer.uber.com/docs/deliveries/references/api/v1.2/deliveries-delivery_id-receipt-get)

### Get delivery ratings
Retrieve the available ratings for a delivery.

```ruby
ratings = client.deliveries.ratings('8b58bc58-7352-4278-b569-b5d24d8e3f76')
# Array of Uber::Delivery::Rating
ratings.size #=> 2
ratings[0].waypoint #=> 'pickup'
```
More details can be found [here](https://developer.uber.com/docs/deliveries/references/api/v1.2/deliveries-delivery_id-ratings-get)

### Submit a rating
Submit a rating for a delivery.

```ruby
status = client.deliveries.add_rating('8b58bc58-7352-4278-b569-b5d24d8e3f76',
                                          {"waypoint"=>"dropoff",
                                           "rating_type"=>"binary",
                                           "rating_value"=>0,
                                           "tags"=>["courier_not_on_time", "delivery_in_good_condition"],
                                           "comments"=>"Courier was not professionally dressed."})
# Returns the status code, with no content
status #=> 204                                           
```
More details can be found [here](https://developer.uber.com/docs/deliveries/references/api/v1.2/deliveries-delivery_id-ratings-post)

### Get rating tags
Retrieve the available rating tags for a delivery

```ruby
tags = client.deliveries.rating_tags('8b58bc58-7352-4278-b569-b5d24d8e3f76')
# Array of Uber::Deliery::RatingTag
tags.size #=> 2
tags[0].waypoint #=> 'pickup'
tags.tags #=> Array of rating tags for delivery 
```
More details can be found [here](https://developer.uber.com/docs/deliveries/references/api/v1.2/deliveries-delivery_id-rating_tags-get)

### Cancel a delivery
Cancel an existing delivery.

```ruby
status = client.deliveries.cancel('8b58bc58-7352-4278-b569-b5d24d8e3f76')
status #=> 204
```
More details can be found [here](https://developer.uber.com/docs/deliveries/references/api/v1.2/deliveries-delivery_id-cancel-post)

### Get service regions
Returns all regions where UberRUSH is available.

```ruby
regions = client.deliveries.regions
# Array of Uber::Delivery::Region
regions[0].city #=> 'San Francisco'
```
More details can be found [here](https://developer.uber.com/docs/deliveries/references/api/v1.2/deliveries-regions-get)

## Contributors

* [Arun Thampi](https://github.com/arunthampi)
* [Ankur Goel](https://github.com/AnkurGel)

## Contributing

1. Fork it ( http://github.com/sishen/uber-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

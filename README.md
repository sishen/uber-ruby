# The Uber Ruby Gem

A Ruby interface to the Uber API.

## Installation

Add this line to your application's Gemfile:

    gem 'uber-ruby'

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

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( http://github.com/<my-github-username>/uber-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

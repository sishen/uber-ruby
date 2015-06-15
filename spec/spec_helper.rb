require 'rspec'
require 'webmock/rspec'

Dir[File.join(File.dirname(__FILE__), "./support/**/*.rb")].each do |f|
  require f
end

RSpec.configure do |c|
  c.include ClientHelpers

  c.before :each do
    WebMock.disable_net_connect!(allow_localhost: true)
  end
end

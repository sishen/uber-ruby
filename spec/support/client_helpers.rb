require 'uber'

module ClientHelpers
  def setup_client
    Uber::Client.new { |c| c.bearer_token = 'UBER_BEARER_TOKEN' }
  end

  def stub_uber_request(method, api_endpoint, response_hash)
    stub_request(method, "https://api.uber.com/#{api_endpoint}").
      with(headers: {'Authorization' => 'Bearer UBER_BEARER_TOKEN'}).
      to_return(status: 200, body: response_hash.to_json)
  end
end

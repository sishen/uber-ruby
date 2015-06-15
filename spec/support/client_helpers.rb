require 'uber'

module ClientHelpers
  def setup_client
    Uber::Client.new { |c| c.bearer_token = 'UBER_BEARER_TOKEN' }
  end

  def stub_uber_request(method, api_endpoint, response_hash, opts = {})
    with_opts = {headers: {'Authorization' => 'Bearer UBER_BEARER_TOKEN'}}
    with_opts[:body] = opts[:body] unless opts[:body].nil?
    status_code = opts[:status_code] || 200

    stub_request(method, "https://api.uber.com/#{api_endpoint}").
      with(with_opts).
      to_return(status: status_code, body: response_hash.to_json)
  end
end

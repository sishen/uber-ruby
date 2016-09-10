require 'uber'

module ClientHelpers
  def setup_client(opts = {})
    Uber::Client.new do |c|
      c.bearer_token = 'UBER_BEARER_TOKEN'
      c.sandbox      = opts[:sandbox]
      c.debug        = opts[:debug]
    end
  end

  def stub_uber_request(method, api_endpoint, response_hash, opts = {})
    with_opts = {headers: {'Authorization' => 'Bearer UBER_BEARER_TOKEN'}}
    with_opts[:body] = opts[:body] unless opts[:body].nil?
    status_code = opts[:status_code] || 200

    host = opts[:sandbox] ? Uber::Client::SANDBOX_ENDPOINT : Uber::Client::ENDPOINT

    response = response_hash.nil? ? "" : response_hash.to_json

    stub_request(method, "#{host}/#{api_endpoint}").
      with(with_opts).
      to_return(status: status_code, body: response)
  end
end

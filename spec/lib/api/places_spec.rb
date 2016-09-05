require "spec_helper"
require "uber"

describe Uber::API::Places do
  let!(:client) { setup_client }

  before do
    stub_uber_request(:get, 'v1/places/home', {address: 'Mumbai, India'})
  end

  it 'should return information about place' do
    place_request = client.places('home')
    expect(place_request.class).to eql Uber::Place
    expect(place_request.address).to eql 'Mumbai, India'
  end

  describe 'update' do
    before do
      stub_uber_request(:put, 'v1/places/work', {address: 'Mumbai, Maharashtra, India'}, body: {address: 'Mumbai, India'}.to_json)
    end

    it 'should save and return correct address' do
      place_request = client.place_update('work', 'Mumbai, India')
      expect(place_request.class).to eql Uber::Place
      expect(place_request.address).to eql 'Mumbai, Maharashtra, India'
    end
  end

end
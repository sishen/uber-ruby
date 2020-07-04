require "spec_helper"
require "uber"

describe Uber::API::Me do
  let!(:client) { setup_client }

  let(:response_body) do
    # From: https://developer.uber.com/docs/riders/references/api/v1.2/me-get
    {
      picture: "https://d1w2poirtb3as9.cloudfront.net/f3be498cb0bbf570aa3d.jpeg",
      first_name: "Uber",
      last_name: "Developer",
      uuid: "f4a416e3-6016-4623-8ec9-d5ee105a6e27",
      rider_id: "8OlTlUG1TyeAQf1JiBZZdkKxuSSOUwu2IkO0Hf9d2HV52Pm25A0NvsbmbnZr85tLVi-s8CckpBK8Eq0Nke4X-no3AcSHfeVh6J5O6LiQt5LsBZDSi4qyVUdSLeYDnTtirw==",
      email: "uberdevelopers@gmail.com",
      mobile_verified: true,
      promo_code: "uberd340ue"
    }
  end

  before do
    stub_uber_request(:get, "v1.2/me", response_body)
  end

  it "should return the user profile" do
    profile = client.me
    expect(profile.first_name).to eq response_body[:first_name]
    expect(profile.last_name).to eq response_body[:last_name]
    expect(profile.email).to eq response_body[:email]
    expect(profile.picture).to eq response_body[:picture]
    expect(profile.promo_code).to eq response_body[:promo_code]
    expect(profile.uuid).to eq response_body[:uuid]
    expect(profile.rider_id).to eq response_body[:rider_id]
    expect(profile.mobile_verified).to be true
    expect(profile.mobile_verified?).to be true
  end
end

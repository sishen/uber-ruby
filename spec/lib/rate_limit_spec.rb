require "spec_helper"
require "uber"

describe Uber::RateLimit do
  let!(:now) { Time.at(1449638388) }
  let(:rate_limit) { 
    Uber::RateLimit.new({
      'x-rate-limit-limit' => 500,
      'x-rate-limit-remaining' => 499,
      'x-rate-limit-reset' => now.to_i
    })
  }

  it 'should return rate limit values' do
    expect(rate_limit.limit).to eq 500
    expect(rate_limit.remaining).to eq 499
  end

  it 'should provide reset time' do
    allow(Time).to receive(:now) { now - 100 }
    expect(rate_limit.reset_at).to eq now
    expect(rate_limit.reset_in).to eq 100
  end
end



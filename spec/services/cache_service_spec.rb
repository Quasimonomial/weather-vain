require 'rails_helper'

RSpec.describe AddressService do
  let!(:start_time) { Time.local(2025, 3, 25) }

  before(:each) do
    Timecop.freeze(start_time)
  end

  after(:each) do
    Timecop.return
  end

  describe "#cache service" do
    before(:each) do
      CacheService.delete("foo") # prevents spec pollution
    end

    it "can write, read, delete, and check existance of keys in the cache" do
      expect(CacheService.read("foo")).to be_nil
      expect(CacheService.exist?("foo")).to be false

      expect(CacheService.write("foo", "bar")).to eq("OK")
      expect(CacheService.read("foo")).to eq("bar")
      expect(CacheService.exist?("foo")).to be true

      foo_ttl = CacheService.client.ttl("weather_vain:#{Rails.env}:foo")
      expect(foo_ttl).to be_between(
        CacheService::EXPIRATION_INTERVAL - 30,
        CacheService::EXPIRATION_INTERVAL
      ).inclusive

      expect(CacheService.delete("foo")).to eq(1)
      expect(CacheService.read("foo")).to be_nil
      expect(CacheService.exist?("foo")).to be false

      expect(CacheService.delete("foo")).to eq(0)
      expect(CacheService.read("foo")).to be_nil
      expect(CacheService.exist?("foo")).to be false
    end

    it "handles montly api call increases" do
      expect(CacheService.read("foo_api")).to be_nil
      expect(CacheService.increment_api_calls("foo_api")).to eq(1)
      expect(CacheService.increment_api_calls("foo_api")).to eq(2)
      expect(CacheService.increment_api_calls("foo_api")).to eq(3)

      foo_ttl = CacheService.client.ttl("weather_vain:#{Rails.env}:foo_api")
      expect(foo_ttl).to be_between(
        (Time.now.end_of_month.to_i - Time.now.to_i) - 30,
        (Time.now.end_of_month.to_i - Time.now.to_i)
      ).inclusive

      CacheService.delete("foo_api")
    end
  end
end

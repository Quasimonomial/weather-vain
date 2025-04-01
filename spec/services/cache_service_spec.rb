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
  end
end




# class CacheService
#   class << self
#     EXPIRATION_INTERVAL = 30.minutes.to_i

#     def read(key)
#       redis_data = client.get(namespaced_key(key))
#       redis_data.present? ? deserialize(redis_data) : nil
#     end

#     def write(key, value)
#       client.setex(namespaced_key(key), EXPIRATION_INTERVAL, serialize(value))
#     end

#     def delete(key)
#       client.del(namespaced_key(key))
#     end

#     def exist?(key)
#       client.exists?(namespaced_key(key))
#     end

#     private

#     def client
#       @client ||= Redis.new()
#     end

#     def namespaced_key(key)
#       "weather_vain:#{Rails.env}:#{key}"
#     end

#     def serialize(value)
#       value.to_json
#     end

#     def deserialize(value)
#       JSON.parse(value, { symbolize_names: true })
#     end
#   end
# end

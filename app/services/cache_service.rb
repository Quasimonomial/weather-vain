# Redis Docs: https://redis.io/learn/develop/ruby
# Note: For some types of Cache we would want to keep frequently accessed values refreshed, however Weather itself changes and becomes outdated, we acutally want to refresh it periodically

class CacheService
  EXPIRATION_INTERVAL = 30.minutes.to_i

  class << self
    def client
      @client ||= Redis.new()
    end

    def read(key)
      redis_data = client.get(namespaced_key(key))
      redis_data.present? ? deserialize(redis_data) : nil
    end

    def write(key, value)
      client.setex(namespaced_key(key), EXPIRATION_INTERVAL, serialize(value))
    end

    def delete(key)
      client.del(namespaced_key(key))
    end

    def exist?(key)
      client.exists?(namespaced_key(key))
    end

    private

    def namespaced_key(key)
      "weather_vain:#{Rails.env}:#{key}"
    end

    def serialize(value)
      value.to_json
    end

    def deserialize(value)
      JSON.parse(value, { symbolize_names: true })
    end
  end
end

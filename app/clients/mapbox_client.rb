# Documentation for API found here: https://docs.mapbox.com/api/search/geocoding

class MapboxClient < BaseApiClient
  BASE_URL = "https://api.mapbox.com/"
  MONTHLY_FREE_LIMIT= (50 * 1000)
  self.api_key_name = "MAPBOX_API_TOKEN"

  def self.conn
    @@connection ||= Faraday.new(url: BASE_URL, params: { access_token: self.api_key })
  end

  def self.geocode_string_to_address(query)
    if self.monthly_limit_hit?
      raise ApiErrors::RateLimitError.new(
        "internal monthly limit hit on our side",
        status: 429,
        api_client: MapboxClient
      )
    end

    resp = conn.get("/search/geocode/v6/forward", {
      q: query,
      country: "US"
    })

    self.increment_api_call()

    self.handle_response(resp)
  end

  private
  def self.cache_mapbox_limt_key
    "external_client:rate_limit"
  end

  def self.monthly_limit_hit?
    monthly_usage = CacheService.read(self.cache_mapbox_limt_key)

    !monthly_usage.nil? && monthly_usage >= MapboxClient::MONTHLY_FREE_LIMIT
  end

  def self.increment_api_call
    CacheService.increment_api_calls(self.cache_mapbox_limt_key)
  end
end

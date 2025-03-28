# Documentation for API found here: https://docs.mapbox.com/api/search/geocoding

class MapboxClient < BaseApiClient
  BASE_URL = "https://api.mapbox.com/"
  self.api_key_name = "MAPBOX_API_TOKEN"

  def self.conn
    @@connection ||= Faraday.new(url: BASE_URL, params: { access_token: self.api_key })
  end

  def self.geocode_string_to_address(query)
    resp = conn.get("/search/geocode/v6/forward", {
      q: query
    })
    self.parse_resp_body(resp)
  end
end

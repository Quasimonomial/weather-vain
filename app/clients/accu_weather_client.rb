# Documentation for API found here: https://developer.accuweather.com/apis
# See Packages - we can be VERY limited in our API Calls but we can fall back https://developer.accuweather.com/packages
# Also not using this one because the free tier sucks

class AccuWeatherClient < BaseApiClient
  BASE_URL = "https://dataservice.accuweather.com"
  self.api_key_name = "ACCU_WEATHER_API_KEY"

  def self.conn
    @@connection ||= Faraday.new(
      url: BASE_URL,
      params: { "apikey": self.api_key }
    )
  end

  def self.get_location_from_zip(zip_code)
    resp = conn.get("/locations/v1/postalcodes/search") do |req|
      req.params[:q] = zip_code
    end
    self.handle_response(resp)
  end

  def self.get_forecast_from_location(location_key)
    # 5 days on free plan, 1 period per day
    resp = conn.get("/forecasts/v1/daily/5day/#{location_key}")
    self.handle_response(resp)
  end

  def self.get_forecast_from_location_hourly(location_key)
    # 12 hour forecast on free plan
    resp = conn.get("/forecasts/v1/hourly/12hour/#{location_key}")
    self.handle_response(resp)
  end
end

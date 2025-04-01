# Documentation for API found here: https://www.weather.gov/documentation/services-web-api
# Also it is very funny that this API appears to return GEOJSON https://datatracker.ietf.org/doc/html/rfc7946

class NationalWeatherServiceClient < BaseApiClient
  BASE_URL = "https://api.weather.gov"

  def self.conn
    @@connection ||= Faraday.new(BASE_URL)
  end

  def self.get_weather_forecast_by_grid_daily(grid_x, grid_y)
    # returns a 7 day forcast, 2 periods per day
    resp = conn.get("/gridpoints/MTR/#{grid_x},#{grid_y}/forecast")
    self.handle_response(resp)
  end

  def self.get_weather_forecast_by_grid_hourly(grid_x, grid_y)
    # returns 156 hours or 6 day forcast
    resp = conn.get("/gridpoints/MTR/#{grid_x},#{grid_y}/forecast/hourly")
    self.handle_response(resp)
  end

  def self.get_grid_coords(latitude, longitude)
    latitude, longitude = [ latitude, longitude ].map { |c| self.round_for_api(c) }

    resp = conn.get("/points/#{latitude},#{longitude}")
    self.handle_response(resp)
  end

  private

  def self.round_for_api(coord)
    # National Weather Service accepts 4 digits of percision and returns 301 if you attempt to do more
    coord.round(4)
  end
end

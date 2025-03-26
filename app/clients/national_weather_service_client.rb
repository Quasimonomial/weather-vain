class NationalWeatherServiceClient < BaseApiClient
  BASE_URL = "https://api.weather.gov"

  def self.conn
    @@connection ||= Faraday.new(BASE_URL)
  end

  def self.get_weather_forecast_by_grid(grid_x, grid_y)
    response = conn.get("/gridpoints/MTR/#{grid_x},#{grid_y}/forecast")
    self.parse_resp_body(response)
  end

  def self.get_weather_forecast_by_grid_hourly(grid_x, grid_y)
    response = conn.get("/gridpoints/MTR/#{grid_x},#{grid_y}/forecast/hourly")
    self.parse_resp_body(response)
  end

  def self.get_grid_coords(lat, long)
    # TODO: Cache these as we go
    lat, long = [ lat, long ].map { |c| self.round_for_api(c) }

    response = conn.get("/points/#{lat},#{long}")
    self.parse_resp_body(response)
  end

  private
  def self.round_for_api(coord)
    # National Weather Service accepts 4 digits of percision and returns 301 if you attempt to do more
    coord.round(4)
  end
end

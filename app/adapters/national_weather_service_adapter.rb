class NationalWeatherServiceAdapter
  def self.get_forecast_from_lat_long(latitude, longitude)
    grid_resp = NationalWeatherServiceClient.get_grid_coords(latitude, longitude)
    grid_x = grid_resp[:properties][:gridX]
    grid_y = grid_resp[:properties][:gridY]

    forecast_daily = NationalWeatherServiceClient.get_weather_forecast_by_grid_daily(grid_x, grid_y)
    # forecast_hourly = NationalWeatherServiceClient.get_weather_forecast_by_grid_hourly(grid_x, grid_y)
    formatted_resp = self.format_response_for_weather_vane(forecast_daily[:properties][:periods])
    formatted_resp
  end

  def self.format_response_for_weather_vane(forecast_periods)
    forecast_periods.map do |p|
      precipitation = p[:probabilityOfPrecipitation][:value]
      {
        end_time: p[:endTime],
        start_time: p[:startTime],
        temperature_high: p[:temperature], # we always do in F
        temperature_low: p[:temperature], # NWS gives us one temp object but we can correlate this on the FE since we get multiple samples a day
        precipitation: precipitation.nil? ? 0 : precipitation, # this is in percent
        skies: p[:shortForecast] # TODO: we need to standardize this
      }
    end
  end
end

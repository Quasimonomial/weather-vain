class NationalWeatherServiceAdapter
  def self.get_forecast_from_lat_long(latitude, longitude)
    grid_resp = NationalWeatherServiceClient.get_grid_coords(latitude, longitude)
    office = grid_resp[:properties][:gridId]
    grid_x = grid_resp[:properties][:gridX]
    grid_y = grid_resp[:properties][:gridY]

    forecast_daily = NationalWeatherServiceClient.get_weather_forecast_by_grid_daily(office, grid_x, grid_y)
    formatted_resp = self.format_response_for_weather_vane(forecast_daily[:properties][:periods])
    forecast_combined_by_day = formatted_resp.sort_by { |p| p[:start_time] }.group_by { |p| Date.parse(p[:start_time]) }.map do |d, f|
      {
        start_time: f.first[:start_time],
        end_time: f.last[:end_time],
        temperature_high: f.map { |p| p[:temperature_high] }.max, # we always do in F
        temperature_low: f.map { |p| p[:temperature_low] }.min,
        precipitation: f.first[:precipitation], # assuming we care about the daytime weather more
        skies: f.first[:skies]
      }
    end
    forecast_combined_by_day
  end

  def self.format_response_for_weather_vane(forecast_periods)
    forecast_periods.map do |p|
      precipitation = p[:probabilityOfPrecipitation][:value]
      {
        start_time: p[:startTime],
        end_time: p[:endTime],
        temperature_high: p[:temperature], # we always do in F
        temperature_low: p[:temperature], # NWS gives us one temp object but we can correlate this on the FE since we get multiple samples a day
        precipitation: precipitation == "null" ? 0 : precipitation, # this is in percent
        skies: NationalWeatherServiceAdapter.standardize_skies(p[:shortForecast])
      }
    end
  end

  def self.standardize_skies(short_forecast)
    forecast = short_forecast.downcase

    return :storm if forecast.match?(/thunderstorm|storm/)
    return :snow if forecast.match?(/snow|flurries|blizzard/)
    return :rain if forecast.match?(/rain|showers/)
    return :partly_cloudy if forecast.match?(/partly|mostly/) # what else is partly lol
    return :cloudy if forecast.match?(/cloudy|overcast/)
    return :sunny if forecast.match?(/sunny|clear/)
    :unknown
  end
end

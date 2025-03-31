class AppleWeatherkitAdapter
  def self.get_forecast_from_lat_long(latitude, longitude)
    forecast_resp = AppleWeatherkitClient.instance.get_weather_forecast_daily(latitude, longitude)

    formatted_resp = self.format_response_for_weather_vane(forecast_resp[:forecastDaily][:days])
    formatted_resp
  end

  def self.format_response_for_weather_vane(forecast_periods)
    forecast_periods.map do |d|
      {
        start_time: d[:daytimeForecast][:forecastStart],
        end_time: d[:daytimeForecast][:forecastEnd],
        temperature_low: self.convert_temp_c_to_f(
          d[:daytimeForecast][:temperatureMin]
        ).to_i, # we always do in F
        temperature_high: self.convert_temp_c_to_f(
          d[:daytimeForecast][:temperatureMax]
        ).to_i, # we always do in F
        precipitation: d[:daytimeForecast][:precipitationChance] * 100.0, # this is in percent
        skies: d[:daytimeForecast][:conditionCode] # TODO: we need to standardize this
      }
    end
  end

  def self.convert_temp_c_to_f(c)
    9.0/5.0 * c + 32
  end
end

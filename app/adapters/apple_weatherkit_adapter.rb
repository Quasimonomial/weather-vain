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
        precipitation: (d[:daytimeForecast][:precipitationChance] * 100.0).round, # this is in percent
        skies: standardize_skies(d[:daytimeForecast][:conditionCode])
      }
    end
  end

  def self.standardize_skies(condition_code)
    # Very difficult to find the possible values the condition codes can take https://gist.github.com/mikesprague/048a93b832e2862050356ca233ef4dc1

    case condition_code
    when "Clear"
      :sunny
    when "Frigid"
      :sunny # I think?
    when "Cloudy"
      :cloudy
    when "MostlyClear"
      :partly_cloudy
    when "MostlyCloudy"
      :partly_cloudy
    when "PartlyCloudy"
      :partly_cloudy
    when "Drizzle"
      :rain
    when "HeavyRain"
      :rain
    when "Rain"
      :rain
    when "SunShowers"
      :rain
    when "IsolatedThunderstorms"
      :storm
    when "ScatteredThunderstorms"
      :storm
    when "StrongStorms"
      :storm
    when "Thunderstorms"
      :storm
    when "Hail"
      :snow
    when "Hot"
      :snow
    when "Flurries"
      :snow
    when "Sleet"
      :snow
    when "Snow"
      :snow
    when "SunFlurries"
      :snow
    when "WintryMix"
      :snow
    when "Blizzard"
      :snow
    when "BlowingSnow"
      :snow
    when "FreezingDrizzle"
      :snow
    when "FreezingRain"
      :snow
    when "HeavySnow"
      :snow
    else
      :unknown # my app doesn't warn you about hurricane's sorry
    end
  end

  def self.convert_temp_c_to_f(c)
    (9.0/5.0 * c + 32).round
  end
end

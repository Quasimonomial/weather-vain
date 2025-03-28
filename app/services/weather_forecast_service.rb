class WeatherForecastService
  def self.get_forecast_by_zip(zip_code)
    WeatherForecastService.get_forecast_by_lat_long(zip_code.latitude, zip_code.longitude)
  end

  def self.get_forecast_by_lat_long(latitude, longitude)
    begin
      forecast = AppleWeatherkitAdapter.get_forecast_from_lat_long(latitude, longitude)
    rescue => e
      forecast = NationalWeatherServiceAdapter.get_forecast_from_lat_long(latitude, longitude)
    end

    forecast
  end
end

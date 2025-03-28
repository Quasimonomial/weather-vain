class WeatherForecastService
  def self.get_forecast_by_zip(zip_code)
    if CacheService.exist?(self.cache_forecast_zip_key(zip_code.code))
      CacheService.read(self.cache_forecast_zip_key(zip_code.code))
    else
      WeatherForecastService.get_forecast_by_lat_long(zip_code)
    end
  end

  def self.get_forecast_by_lat_long(zip_code)
    latitude = zip_code.latitude
    longitude = zip_code.longitude
    begin
      forecast = AppleWeatherkitAdapter.get_forecast_from_lat_long(latitude, longitude)
    rescue => e
      forecast = NationalWeatherServiceAdapter.get_forecast_from_lat_long(latitude, longitude)
    end

    CacheService.write(self.cache_forecast_zip_key(zip_code.code), forecast)

    forecast
  end

  private
  def self.cache_forecast_zip_key(zip_code)
    "forecast:z:#{zip_code}"
  end
end

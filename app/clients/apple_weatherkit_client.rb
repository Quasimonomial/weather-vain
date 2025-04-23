# Documentation for API found here https://developer.apple.com/documentation/weatherkitrestapi
require "singleton"

class AppleWeatherkitClient < BaseApiClient
  include Singleton

  BASE_URL = "https://weatherkit.apple.com"

  def initialize
    @connection ||= Faraday.new(BASE_URL)
    @jwt_service = JwtService.new()
  end

  def conn
    @connection
  end

  def get_weather_forecast(latitude, longitude)
    resp = conn.get("/api/v1/weather/en/#{latitude}/#{longitude}", {
      countryCode: "US",
      dataSets: "forecastDaily,forecastHourly",
      dailyEnd: (Time.now + 7.days).iso8601,
      hourlyEnd: (Time.now + 7.days).iso8601
    }) do |req|
      req.headers["Authorization"] = "Bearer #{@jwt_service.get_valid_jwt}"
    end

    AppleWeatherkitClient.handle_response(resp)
  end

  def get_weather_forecast_daily(latitude, longitude)
    resp = conn.get("/api/v1/weather/en/#{latitude}/#{longitude}", {
      countryCode: "US",
      dataSets: "forecastDaily",
      dailyEnd: (Time.now + 7.days).iso8601
    }) do |req|
      req.headers["Authorization"] = "Bearer #{@jwt_service.get_valid_jwt}"
    end

    AppleWeatherkitClient.handle_response(resp)
  end

  def get_weather_forecast_hourly(latitude, longitude)
    resp = conn.get("/api/v1/weather/en/#{latitude}/#{longitude}", {
      countryCode: "US",
      dataSets: "forecastHourly",
      hourlyEnd: (Time.now + 7.days).iso8601
    }) do |req|
      req.headers["Authorization"] = "Bearer #{@jwt_service.get_valid_jwt}"
    end

    AppleWeatherkitClient.handle_response(resp)
  end
end

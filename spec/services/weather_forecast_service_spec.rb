require "rails_helper"

describe WeatherForecastService do
  let(:zip_code_model) do
    create(:zip_code, {
      code: "46223",
      latitude: 46.91456,
      longitude: -103.99091
    })
  end

  let(:zip_code_key) { "forecast:z:#{zip_code_model.code}" }

  let(:week_forecast) do
      [
        { start_time: "2025-03-31T14:00:00Z", end_time: "2025-04-01T02:00:00Z", temperature_low: 60, temperature_high: 74, precipitation: 0, skies: "MostlyCloudy" },
        { start_time: "2025-04-01T14:00:00Z", end_time: "2025-04-02T02:00:00Z", temperature_low: 50, temperature_high: 64, precipitation: 0, skies: "PartlyCloudy" },
        { start_time: "2025-04-02T14:00:00Z", end_time: "2025-04-03T02:00:00Z", temperature_low: 45, temperature_high: 58, precipitation: 26, skies: "MostlyCloudy" },
        { start_time: "2025-04-03T14:00:00Z", end_time: "2025-04-04T02:00:00Z", temperature_low: 44, temperature_high: 62, precipitation: 0, skies: "MostlyClear" },
        { start_time: "2025-04-04T14:00:00Z", end_time: "2025-04-05T02:00:00Z", temperature_low: 47, temperature_high: 67, precipitation: 0, skies: "PartlyCloudy" },
        { start_time: "2025-04-05T14:00:00Z", end_time: "2025-04-06T02:00:00Z", temperature_low: 51, temperature_high: 69, precipitation: 0, skies: "MostlyClear" },
        { start_time: "2025-04-06T14:00:00Z", end_time: "2025-04-07T02:00:00Z", temperature_low: 53, temperature_high: 73, precipitation: 0, skies: "Clear" }
      ]
  end

  describe ".get_forecast_by_zip" do
    context "zip code's forecast found in cache" do
      before(:each) do
        CacheService.write(zip_code_key, week_forecast)
      end

      it "returns the forecast from the cache" do
        expect(WeatherForecastService).to_not receive(:get_forecast_by_lat_long)

        forecast = WeatherForecastService.get_forecast_by_zip(zip_code_model)
        expect(forecast).to eq(week_forecast)
      end
    end

    context "zip code not found in cache" do
      before(:each) do
        CacheService.exist?(zip_code_key)
        CacheService.delete(zip_code_key)
      end

      it "returns the forecast from the Api Adapters" do
        expect(WeatherForecastService).to receive(:get_forecast_by_lat_long).with(zip_code_model)
          .and_return(week_forecast)

        forecast = WeatherForecastService.get_forecast_by_zip(zip_code_model)
        expect(forecast).to eq(week_forecast)
      end
    end
  end

  describe ".get_forecast_by_lat_long" do
    context "Apple Service succeeds" do
      it "Calls the Apple API and retrieves the forecast" do
        expect(AppleWeatherkitAdapter).to receive(:get_forecast_from_lat_long)
          .with(46.91456, -103.99091)
          .and_return(week_forecast)

        result = WeatherForecastService.get_forecast_by_lat_long(zip_code_model)
        expect(result).to eq(week_forecast)
      end

      it "writes the resulting forecast to the zip code cache" do
        expect(AppleWeatherkitAdapter).to receive(:get_forecast_from_lat_long)
          .with(46.91456, -103.99091)
          .and_return(week_forecast)
        expect(CacheService).to receive(:write).with(zip_code_key, week_forecast)

        WeatherForecastService.get_forecast_by_lat_long(zip_code_model)
      end
    end

    context "Apple Service is unreliable" do
      it "Calls the National Weather Service API and retrieves the forecast" do
        expect(AppleWeatherkitAdapter).to receive(:get_forecast_from_lat_long)
          .and_raise(ApiErrors::ApiKeyMissing)
        expect(NationalWeatherServiceAdapter).to receive(:get_forecast_from_lat_long)
          .with(46.91456, -103.99091)
          .and_return(week_forecast)

        result = WeatherForecastService.get_forecast_by_lat_long(zip_code_model)
        expect(result).to eq(week_forecast)
      end
    end
  end
end

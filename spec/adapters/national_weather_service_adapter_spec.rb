require "rails_helper"

describe NationalWeatherServiceAdapter do
  include ApiHelpers::NationalWeatherService

  let(:adapted_forecast) do
    # Yeah we get Null percipitation chance when the short forcast tells us there is a chance, I think this depends on the actual office/station you hit
    [
      { start_time: "2025-03-31T20:00:00-07:00", end_time: "2025-04-01T06:00:00-07:00", temperature_high: 48, temperature_low: 48, precipitation: 0, skies: :rain },
      { start_time: "2025-04-01T06:00:00-07:00", end_time: "2025-04-01T18:00:00-07:00", temperature_high: 58, temperature_low: 58, precipitation: 0, skies: :storm },
      { start_time: "2025-04-01T18:00:00-07:00", end_time: "2025-04-02T06:00:00-07:00", temperature_high: 44, temperature_low: 44, precipitation: 0, skies: :partly_cloudy },
      { start_time: "2025-04-02T06:00:00-07:00", end_time: "2025-04-02T18:00:00-07:00", temperature_high: 61, temperature_low: 61, precipitation: 0, skies: :sunny },
      { start_time: "2025-04-02T18:00:00-07:00", end_time: "2025-04-03T06:00:00-07:00", temperature_high: 44, temperature_low: 44, precipitation: 0, skies: :partly_cloudy },
      { start_time: "2025-04-03T06:00:00-07:00", end_time: "2025-04-03T18:00:00-07:00", temperature_high: 62, temperature_low: 62, precipitation: 0, skies: :sunny },
      { start_time: "2025-04-03T18:00:00-07:00", end_time: "2025-04-04T06:00:00-07:00", temperature_high: 45, temperature_low: 45, precipitation: 0, skies: :sunny },
      { start_time: "2025-04-04T06:00:00-07:00", end_time: "2025-04-04T18:00:00-07:00", temperature_high: 67, temperature_low: 67, precipitation: 0, skies: :sunny },
      { start_time: "2025-04-04T18:00:00-07:00", end_time: "2025-04-05T06:00:00-07:00", temperature_high: 48, temperature_low: 48, precipitation: 0, skies: :partly_cloudy },
      { start_time: "2025-04-05T06:00:00-07:00", end_time: "2025-04-05T18:00:00-07:00", temperature_high: 72, temperature_low: 72, precipitation: 0, skies: :sunny },
      { start_time: "2025-04-05T18:00:00-07:00", end_time: "2025-04-06T06:00:00-07:00", temperature_high: 49, temperature_low: 49, precipitation: 0, skies: :partly_cloudy },
      { start_time: "2025-04-06T06:00:00-07:00", end_time: "2025-04-06T18:00:00-07:00", temperature_high: 73, temperature_low: 73, precipitation: 0, skies: :sunny },
      { start_time: "2025-04-06T18:00:00-07:00", end_time: "2025-04-07T06:00:00-07:00", temperature_high: 50, temperature_low: 50, precipitation: 0, skies: :rain },
      { start_time: "2025-04-07T06:00:00-07:00", end_time: "2025-04-07T18:00:00-07:00", temperature_high: 68, temperature_low: 68, precipitation: 0, skies: :partly_cloudy }
    ]
  end

  let(:combined_forecast) do
    [
      { start_time: "2025-03-31T20:00:00-07:00", end_time: "2025-04-01T06:00:00-07:00", temperature_high: 48, temperature_low: 48, precipitation: 0, skies: :rain },
      { start_time: "2025-04-01T06:00:00-07:00", end_time: "2025-04-02T06:00:00-07:00", temperature_high: 58, temperature_low: 44, precipitation: 0, skies: :storm },
      { start_time: "2025-04-02T06:00:00-07:00", end_time: "2025-04-03T06:00:00-07:00", temperature_high: 61, temperature_low: 44, precipitation: 0, skies: :sunny },
      { start_time: "2025-04-03T06:00:00-07:00", end_time: "2025-04-04T06:00:00-07:00", temperature_high: 62, temperature_low: 45, precipitation: 0, skies: :sunny },
      { start_time: "2025-04-04T06:00:00-07:00", end_time: "2025-04-05T06:00:00-07:00", temperature_high: 67, temperature_low: 48, precipitation: 0, skies: :sunny },
      { start_time: "2025-04-05T06:00:00-07:00", end_time: "2025-04-06T06:00:00-07:00", temperature_high: 72, temperature_low: 49, precipitation: 0, skies: :sunny },
      { start_time: "2025-04-06T06:00:00-07:00", end_time: "2025-04-07T06:00:00-07:00", temperature_high: 73, temperature_low: 50, precipitation: 0, skies: :sunny },
      { start_time: "2025-04-07T06:00:00-07:00", end_time: "2025-04-07T18:00:00-07:00", temperature_high: 68, temperature_low: 68, precipitation: 0, skies: :partly_cloudy }
    ]
  end

  describe ".get_forecast_from_lat_long" do
    it "returns the standardized weather from the correct weather station as determined by grid coordinates" do
      nws_stub_forecast_d_with_resp({
        office: "VEF", # Stub these values with what we get from the grid response, not exactly what we get in prod
        grid_x: 121,
        grid_y: 96
      }, nws_forecast_d_200_resp_json)

      nws_stub_grid_200_with_resp({
        latitude: 36.1266,
        longitude: -115.1655
      }, nws_grid_200_resp_json)

      standardized_forecast = NationalWeatherServiceAdapter.get_forecast_from_lat_long(36.1266, -115.1655)

      expect(standardized_forecast).to eq(combined_forecast)
    end
  end

  describe ".format_response_for_weather_vane" do
    it "formats the response into a standard weather object" do
      standardized_forecast = NationalWeatherServiceAdapter.format_response_for_weather_vane(nws_forecast_d_200_resp_json[:properties][:periods])

      expect(standardized_forecast).to eq(adapted_forecast)
    end
  end

  describe ".standardize_skies" do
    it "transforms the short forecast into a standard sky weather type" do
      expect(NationalWeatherServiceAdapter.standardize_skies("Chance Light Rain")).to eq(:rain)
      expect(NationalWeatherServiceAdapter.standardize_skies("Mostly Clear")).to eq(:partly_cloudy)
      expect(NationalWeatherServiceAdapter.standardize_skies("Partly Cloudy")).to eq(:partly_cloudy)
      expect(NationalWeatherServiceAdapter.standardize_skies("Chance Showers And Thunderstorms")).to eq(:storm)
      expect(NationalWeatherServiceAdapter.standardize_skies("Very Cloudy and also it is going to Snow")).to eq(:snow)
      expect(NationalWeatherServiceAdapter.standardize_skies("Sunny")).to eq(:sunny)
      expect(NationalWeatherServiceAdapter.standardize_skies("Clear")).to eq(:sunny)
      expect(NationalWeatherServiceAdapter.standardize_skies("Wizard Weather")).to eq(:unknown)
    end
  end
end

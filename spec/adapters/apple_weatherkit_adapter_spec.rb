require "rails_helper"

describe AppleWeatherkitAdapter do
  include ApiHelpers::AppleWeatherkit

  let!(:time_now) { Time.local(2025, 3, 25) }

  let(:adapted_forecast) do
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

  before(:each) do
    Timecop.freeze(time_now)
  end

  after(:each) do
    Timecop.return
  end

  describe ".get_forecast_from_lat_long" do
    it "returns the normalized daily forecasts" do
      awk_stub_forecast_d_with_resp({
        latitude: 36.1266,
        longitude: -115.1655
      }, awk_forecast_d_200_resp_json, time_now)

      standardized_forecast = AppleWeatherkitAdapter.get_forecast_from_lat_long(36.1266, -115.1655)
      expect(standardized_forecast).to eq(adapted_forecast)
    end
  end

  describe ".format_response_for_weather_vane" do
    it "returns the normalized daily forecasts" do
      standardized_forecast = AppleWeatherkitAdapter.format_response_for_weather_vane(awk_forecast_d_200_resp_json[:forecastDaily][:days])
      expect(standardized_forecast).to eq(adapted_forecast)
    end
  end

  describe '.standardize_skies' do
    {
      "Clear" => :sunny,
      "Frigid" => :sunny,
      "Cloudy" => :cloudy,
      "MostlyClear" => :partly_cloudy,
      "MostlyCloudy" => :partly_cloudy,
      "PartlyCloudy" => :partly_cloudy,
      "Drizzle" => :rain,
      "HeavyRain" => :rain,
      "Rain" => :rain,
      "SunShowers" => :rain,
      "IsolatedThunderstorms" => :storm,
      "ScatteredThunderstorms" => :storm,
      "StrongStorms" => :storm,
      "Thunderstorms" => :storm,
      "Hail" => :snow,
      "Hot" => :snow,
      "Flurries" => :snow,
      "Sleet" => :snow,
      "Snow" => :snow,
      "SunFlurries" => :snow,
      "WintryMix" => :snow,
      "Blizzard" => :snow,
      "BlowingSnow" => :snow,
      "FreezingDrizzle" => :snow,
      "FreezingRain" => :snow,
      "HeavySnow" => :snow,
      "AlienInvasion" => :unknown
    }.each do |input, expected|
      it "returns #{expected} for #{input}" do
        expect(AppleWeatherkitAdapter.standardize_skies(input)).to eq(expected)
      end
    end
  end

  describe '.convert_temp_c_to_f' do
    {
      0 => 32,
      100 => 212,
      -40 => -40,
      37 => 99
    }.each do |c, f|
      it "converts #{c}°C to #{f}°F" do
        expect(AppleWeatherkitAdapter.convert_temp_c_to_f(c)).to eq(f)
      end
    end
  end
end

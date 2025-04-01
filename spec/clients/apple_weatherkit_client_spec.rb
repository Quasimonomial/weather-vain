require 'rails_helper'

describe AppleWeatherkitClient do
  include ApiHelpers::AppleWeatherkit

  let!(:time_now) { Time.local(2025, 3, 25) }

  before(:each) do
    Timecop.freeze(time_now)
  end

  after(:each) do
    Timecop.return
  end

  describe ".get_weather_forecast_daily" do
    it "returns the weather forecast response" do
      awk_stub_forecast_d_with_resp({
        latitude: 36.1266,
        longitude: -115.1655
      }, awk_forecast_d_200_resp_json, time_now)

      forecast_resp = AppleWeatherkitClient.instance.get_weather_forecast_daily(36.1266, -115.1655)

      expect(forecast_resp).to eq(awk_forecast_d_200_resp_json)
    end
  end
end

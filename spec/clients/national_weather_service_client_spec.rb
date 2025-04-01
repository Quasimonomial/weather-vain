require 'rails_helper'

RSpec.describe NationalWeatherServiceClient do
  include ApiHelpers::NationalWeatherService

  describe ".get_weather_forecast_by_grid_daily" do
    context "data is available" do
      it "returns 200 with the weather data" do
        nws_stub_forecast_d_with_resp({
          office: "MTR",
          grid_x: 91,
          grid_y: 106
        }, nws_forecast_d_200_resp_json)

        forecast_resp = NationalWeatherServiceClient.get_weather_forecast_by_grid_daily("MTR", 91, 106)

        expect(forecast_resp).to eq(nws_forecast_d_200_resp_json)
      end
    end

    context "there is an external server error" do
      it "throws an Api ServerError" do
        nws_stub_forecast_d_500({
          office: "MTR", # wrong office for this grid
          grid_x: 121,
          grid_y: 96
        })

        expect {
          NationalWeatherServiceClient.get_weather_forecast_by_grid_daily("MTR", 121, 96)
        }.to raise_error(ApiErrors::ServerError)
      end
    end
  end

  describe ".get_grid_coords" do
    context "request is well formed" do
      it "returns the grid data" do
        nws_stub_grid_200_with_resp({
          latitude: 36.1266,
          longitude: -115.1655
        }, nws_grid_200_resp_json)

        grid_resp = NationalWeatherServiceClient.get_grid_coords(36.126591, -115.165520)

        expect(grid_resp).to eq(nws_grid_200_resp_json)
      end
    end

    context "request is improperly formatted" do
      it "throws an Api bad request error" do
        nws_stub_grid_400({
          latitude: 9999,
          longitude: -9999
        })

        expect {
          NationalWeatherServiceClient.get_grid_coords(9999, -9999)
        }.to raise_error(ApiErrors::BadRequestError)
      end
    end
  end
end

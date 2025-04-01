require "rails_helper"

RSpec.describe Api::V1::ForecastsController, type: :controller do
  describe "POST #create" do
    context "with valid params" do
      let(:params) do
        {
          forecast: { address: {
            street_address: "415 Mission St",
            city: "San Francisco",
            country: "US",
            state: "CA",
            zip_code: "94105"
          } }
        }
      end
      let!(:zip_code_model) { create(:zip_code, { code:  "94105", latitude: 30, longitude: -100 }) }
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

      context "with successful weather forecast found" do
        it "returns 200 success" do
          expect(WeatherForecastService).to receive(:get_forecast_by_zip).with(zip_code_model).and_return(week_forecast)

          post :create, params: params

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body, symbolize_names: true)).to eq({ forecast: week_forecast })
        end
      end

      context "with errors in forecast processing" do
        it "returns 500 internal service error" do
          expect(WeatherForecastService).to receive(:get_forecast_by_zip).and_raise(StandardError)

          post :create, params: params

          expect(response).to have_http_status(:internal_server_error)
          expect(JSON.parse(response.body, symbolize_names: true)[:error]).to eq(
            "Failed to process Forecast, there is no weather today, please do not look outside"
          )
        end
      end
    end

    context "with missing zip" do
      let(:params) do
        {
          forecast: { address: {
            street_address: "415 Mission St",
            city: "San Francisco",
            country: "US",
            state: "CA"
          } }
        }
      end

      it "returns 400 bad request" do
        post :create, params: params

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body, symbolize_names: true)[:error]).to eq(
          "Zip Code is required!"
        )
      end
    end

    context "with zip not in use" do
      let(:params) do
        {
          forecast: { address: {
            street_address: "415 Mission St",
            city: "San Francisco",
            country: "US",
            state: "CA",
            zip_code: "94105"
          } }
        }
      end
      let!(:unallocated_zip) { create(:unused_zip_code, { code:  "94105" }) }

      it "returns 404 not found" do
        post :create, params: params

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body, symbolize_names: true)[:error]).to eq(
          "Zip Code is not in use!"
        )
      end
    end

    context "with malformed zip" do
      let(:params) do
        {
          forecast: { address: {
            street_address: "415 Mission St",
            city: "San Francisco",
            country: "US",
            state: "CA",
            zip_code: "Salesforce"
          } }
        }
      end

      it "returns 404 not found" do
        post :create, params: params

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body, symbolize_names: true)[:error]).to eq(
          "Zip Code is malformed!"
        )
      end
    end
  end
end

require "swagger_helper"

RSpec.describe "api/v1/forecasts", type: :request do
  path "/api/v1/forecasts" do
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
    let!(:unallocated_zip_code_model) { create(:unused_zip_code, { code:  "94106" }) }
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

    post("request forecast") do
      tags "Forecasts"
      consumes "application/json"
      parameter name: :address, in: :body, schema: { '$ref' => '#/components/schemas/forecast_query' }


      response(200, "successful") do
        before(:each) do
          expect(WeatherForecastService).to receive(:get_forecast_by_zip).with(zip_code_model).and_return(week_forecast)
        end

        schema '$ref' => '#/components/schemas/forecast_resp'

        let(:address) { { address: { street_name: "123 fake street", zip_code: "94105" } } }
        run_test!
      end

      response(400, "Bad or Missing Zip Code") do
        schema type: :object, properties: { error: { type: :string } }

        let(:address) { { address: { street_name: "123 fake street", zip_code: "" } } }
        run_test!
      end

      response(404, "Address / Weather Forecast not found!") do
        schema type: :object, properties: { error: { type: :string } }

        let(:address) { { address: { street_name: "123 fake street", zip_code: "94106" } } }
        run_test!
      end

      response(500, "some kind of internal error") do
        schema type: :object, properties: { error: { type: :string } }

        before(:each) do
          allow(WeatherForecastService).to receive(:get_forecast_by_zip).and_raise(StandardError)
        end

        let(:address) { { address: { street_name: "123 fake street", zip_code: "94105" } } }
        run_test!
      end
    end
  end
end

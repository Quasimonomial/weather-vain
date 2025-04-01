module ApiHelpers
  module NationalWeatherService
    def nws_stub_forecast_d_with_resp(query_params, resp_body)
      url = "https://api.weather.gov/gridpoints/#{query_params[:office]}/#{query_params[:grid_x]},#{query_params[:grid_y]}/forecast"

      stub_request(:get, url).to_return(
        status: 200,
        body: resp_body.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    def nws_stub_forecast_d_500(query_params)
      url = "https://api.weather.gov/gridpoints/#{query_params[:office]}/#{query_params[:grid_x]},#{query_params[:grid_y]}/forecast"

      error_resp_body_500 = {
        correlationId: "8125847",
        title: "Unexpected Problem",
        type: "https://api.weather.gov/problems/UnexpectedProblem",
        "status": 500,
        detail: "An unexpected problem has occurred. If this error continues, please contact support at nco.ops@noaa.gov.",
        instance: "https://api.weather.gov/requests/8125847"
      }


      stub_request(:get, url).to_return(
        status: 500,
        body: error_resp_body_500.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    def nws_stub_grid_200_with_resp(query_params, resp_body)
      url = "https://api.weather.gov/points/#{query_params[:latitude]},#{query_params[:longitude]}"

      stub_request(:get, url).to_return(
        status: 200,
        body: resp_body.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    def nws_stub_grid_400(query_params)
      url = "https://api.weather.gov/points/#{query_params[:latitude]},#{query_params[:longitude]}"

      error_resp_body_400 = {
        correlationId: "85c9faa",
        title: "Invalid Parameter",
        type: "https://api.weather.gov/problems/InvalidParameter",
        status: 400,
        detail:
          "Parameter \"point\" is invalid: '9999,-9999' does not appear to be a valid coordinate",
        instance: "https://api.weather.gov/requests/85c9faa"
      }

      stub_request(:get, url).to_return(
        status: 400,
        body: error_resp_body_400.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    def nws_grid_200_resp_json
      JSON.parse(
        File.read(Rails.root.join('spec/fixtures/nws_grid_200_resp.json')),
        symbolize_names: true
      )
    end

    def nws_forecast_d_200_resp_json
      JSON.parse(
        File.read(Rails.root.join('spec/fixtures/nws_forecast_d_200_resp.json')),
        symbolize_names: true
      )
    end
  end
end

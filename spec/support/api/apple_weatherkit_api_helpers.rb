module ApiHelpers
  module AppleWeatherkit
    def awk_stub_forecast_d_with_resp(query_params, resp_body, current_time)
      url = "https://weatherkit.apple.com/api/v1/weather/en/#{query_params[:latitude]}/#{query_params[:longitude]}"

      stub_request(:get, url)
        .with(query: {
          countryCode: "US",
          dataSets: "forecastDaily",
          dailyEnd: (current_time + 7.days).iso8601
          # }, headers: {
          # "Authorization" => "Bearer #{@jwt_service.get_valid_jwt}"
        }
        ).to_return(
          status: 200,
          body: resp_body.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    def awk_forecast_d_200_resp_json
      JSON.parse(
        File.read(Rails.root.join('spec/fixtures/apple_wk_200_resp.json')),
        symbolize_names: true
      )
    end
  end
end

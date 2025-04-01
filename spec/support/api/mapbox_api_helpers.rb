module ApiHelpers
  module Mapbox
    def mb_stub_200_with_resp(query_params, resp_body = nil)
      if resp_body.nil?
        resp_body = mapbox_200_resp_json
      end

      stub_request(:get, "https://api.mapbox.com/search/geocode/v6/forward")
        .with(query: mp_default_query.deep_merge!(query_params))
        .to_return(
          status: 200,
          body: resp_body.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    def mb_stub_403_forbidden(query_params)
      stub_request(:get, "https://api.mapbox.com/search/geocode/v6/forward")
        .with(query: mp_default_query.deep_merge!(query_params))
        .to_return(
          status: 401,
          body: {
            message: "Not Authorized - Invalid Token",
            error_code: "INVALID_TOKEN"
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    def mb_stub_429_rate_limit(query_params)
      stub_request(:get, "https://api.mapbox.com/search/geocode/v6/forward")
        .with(query: mp_default_query.deep_merge!(query_params))
        .to_return(
          status: 429,
          body: {
            message: "Too Many Requests",
            error_code: "TOO_MANY_REQUESTS"
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    def mapbox_200_resp_json
      JSON.parse(
        File.read(Rails.root.join('spec/fixtures/mapbox_200_resp.json')),
        symbolize_names: true
      )
    end

    def mp_default_query
      {
        access_token: "VALID_MAPBOX_API_KEY",
        country: "US"
      }
    end
  end
end

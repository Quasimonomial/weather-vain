require 'rails_helper'

RSpec.describe MapboxClient do
  include ApiHelpers::Mapbox

  let(:api_key) { "VALID_MAPBOX_API_KEY" }
  let(:invalid_api_key) { "WRONG_API_KEY" }

  let(:geocoding_query) { "Main Street Post Office" }

  before(:each) do
    ENV["MAPBOX_API_TOKEN"] = api_key
  end

  after(:each) do
    if MapboxClient.class_variable_defined?(:@@connection)
      MapboxClient.remove_class_variable(:@@connection)
    end
  end

  describe ".geocode_string_to_address" do
    context "successful response" do
      it "returns parsed json body" do
        mb_stub_200_with_resp({
          q: geocoding_query,
          access_token: api_key,
          country: "US"
        })

        resp_data = MapboxClient.geocode_string_to_address(geocoding_query)
        expect(resp_data).to eq(mapbox_200_resp_json)
      end
    end

    context "we recieve an auth error" do
      before(:each) do
        ENV["MAPBOX_API_TOKEN"] = invalid_api_key
      end

      it "rails an Api AuthError" do
        mb_stub_403_forbidden({
          q: geocoding_query,
          access_token: invalid_api_key,
          country: "US"
        })

        expect {
          MapboxClient.geocode_string_to_address(geocoding_query)
        }.to raise_error(ApiErrors::AuthError)
      end
    end

    context "we hit the rate limit" do
      # see docs for rate limiting
      # https://docs.mapbox.com/api/overview/#rate-limits

      it "returns an Api RateLimitError" do
        mb_stub_429_rate_limit({
          q: geocoding_query,
          access_token: api_key,
          country: "US"
        })

        expect {
          MapboxClient.geocode_string_to_address(geocoding_query)
        }.to raise_error(ApiErrors::RateLimitError)
      end
    end

    context "api key is not set" do
      before(:each) do
        ENV["MAPBOX_API_TOKEN"] = nil
      end

      it "raises the Api ApiKeyMissing error" do
        mb_stub_200_with_resp({
          q: geocoding_query,
          access_token: api_key,
          country: "US"
        })

        begin
          MapboxClient.geocode_string_to_address(geocoding_query)
          fail "Expected error was not raised"
        rescue ApiErrors::ApiKeyMissing => error
          expect(error.message).to eq("Api Key not defined: MAPBOX_API_TOKEN")
        end
      end
    end
  end
end

require "swagger_helper"

RSpec.describe "api/v1/addresses", type: :request do
  path "/api/v1/addresses" do
    let(:address_query) { "123 Fake Street" }
    let(:service_addresses) do
      [
        {
          street_address: "123 Fake Street",
          city: "Springfield",
          country: "US",
          state: "IL",
          zip_code: "62701"
        }, {
          street_address: "123 Fake Street",
          city: "Springfield",
          country: "US",
          state: "MI",
          zip_code: "48001"
        }
      ]
    end

    before(:each) do |example|
      allow(AddressService).to receive(:get_addresses_from_query)
        .with(address_query)
        .and_return(service_addresses)

      submit_request(example.metadata)
    end

    post("Query for Addresses") do
      tags "Addresses"
      consumes "application/json"
      parameter name: :query, in: :body, schema: { "$ref" => "#/components/schemas/address_search_query" }

      response(200, "successful") do
        schema "$ref" => "#/components/schemas/address_search_resp"

        let(:query) { { query: address_query } }
        run_test!
      end

      response(400, "bad query") do
        schema type: :object, properties: { error: { type: :string } }

        let(:query) { { query: "" } }
        run_test!
      end

      response(500, "internal service error") do
        schema type: :object, properties: { error: { type: :string } }

        before(:each) do
          allow(AddressService).to receive(:get_addresses_from_query).and_raise(StandardError)
        end

        let(:query) { { query: address_query } }
        run_test!
      end
    end
  end
end

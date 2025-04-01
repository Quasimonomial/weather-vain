require 'rails_helper'

RSpec.describe Api::V1::AddressesController, type: :controller do
  describe "POST #create" do
    context "with valid params" do
      let(:address_query) { "123 Fake Street" }
      let(:params) { { address: { query: address_query } } }
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

      before(:each) do
        allow(AddressService).to receive(:get_addresses_from_query)
          .with(address_query)
          .and_return(service_addresses)
      end

      it "returns matching addresses with 200 success" do
        post :create, params: params

        expect(response).to have_http_status(:ok)

        parsed_resp = JSON.parse(response.body, symbolize_names: true)
        expected_resp = {
          address_matches: service_addresses
        }
        expect(parsed_resp).to eq(expected_resp)
      end
    end

    context "with missing query parameter" do
      let(:params) { { address: { query: "" } } }

      it "returns 400 bad request" do
        post :create, params: params
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body, symbolize_names: true)[:error]).to eq(
          "Query is required!"
        )
      end
    end

    context "when service raises an error" do
      let(:params) { { address: { query: "123 Fake St" } } }

      before(:each) do
        allow(AddressService).to receive(:get_addresses_from_query).and_raise(StandardError)
      end

      it "returns 500 internal service error" do
        post :create, params: params
        expect(response).to have_http_status(:internal_server_error)
        expect(JSON.parse(response.body, symbolize_names: true)[:error]).to eq(
          "Failed to process Address Lookup"
        )
      end
    end
  end
  describe "parameters" do
    before(:each) do
      allow(AddressService).to receive(:get_addresses_from_query).with(any_args).and_return([])
    end

    it do
      should permit(:query).for(
        :create,
        params: { address: { query: "query-test" } }
      ).on(:address)
    end
  end
end

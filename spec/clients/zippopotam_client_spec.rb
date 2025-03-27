require 'rails_helper'

RSpec.describe ZippopotamClient do
  include ResponseHelpers::Zippopotam

  let(:valid_zc_resp) { build_resp_valid_zip_code({ "post code".to_sym => some_florida_zip_code}) }
  let(:invalid_zc_resp) { build_resp_invalid_zip_code() }
  let(:some_florida_zip_code) { "32024" }
  let(:some_unallocated_zip_code) { "00000" }

  describe ".get_zipcode_data" do
    context "when the zip code is allocated by the gov" do
      it "calls the zippopotam api and returns the zip code data" do
        stub_request(:get, "http://api.zippopotam.us/us/#{some_florida_zip_code}")
          .to_return(
            status: 200,
            body: valid_zc_resp.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        resp_data = ZippopotamClient.get_zipcode_data(some_florida_zip_code)
        expect(resp_data).to eq(valid_zc_resp)

        expect(WebMock).to have_requested(:get, "http://api.zippopotam.us/us/#{some_florida_zip_code}")
      end
    end

    context "when the zip code is not in use" do
      it "calls the zippopotam api and returns an empty hash" do
        stub_request(:get, "http://api.zippopotam.us/us/#{some_unallocated_zip_code}")
        .to_return(
          status: 200,
          body: invalid_zc_resp.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

        resp_data = ZippopotamClient.get_zipcode_data(some_unallocated_zip_code)
        expect(resp_data).to eq(invalid_zc_resp)

        expect(WebMock).to have_requested(:get, "http://api.zippopotam.us/us/#{some_unallocated_zip_code}")
      end
    end
  end
end

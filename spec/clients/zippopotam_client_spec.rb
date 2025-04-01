require 'rails_helper'

RSpec.describe ZippopotamClient do
  include ApiHelpers::Zippopotam

  let(:valid_zc_resp) { build_resp_valid_zip_code({ "post code".to_sym => some_florida_zip_code }) }
  let(:some_florida_zip_code) { "32024" }
  let(:some_unallocated_zip_code) { "00000" }

  describe ".get_zipcode_data" do
    context "when the zip code is allocated by the gov" do
      it "calls the zippopotam api and returns the zip code data" do
        zp_stub_200_with_resp(some_florida_zip_code, valid_zc_resp)

        resp_data = ZippopotamClient.get_zipcode_data(some_florida_zip_code)
        expect(resp_data).to eq(valid_zc_resp)

        expect(WebMock).to have_requested(:get, "http://api.zippopotam.us/us/#{some_florida_zip_code}")
      end
    end

    context "when the zip code is not in use" do
    it "calls the zippopotam api raises a 404 not found error" do
        zp_stub_400_not_found(some_unallocated_zip_code)

        expect {
          ZippopotamClient.get_zipcode_data(some_unallocated_zip_code)
        }.to raise_error(ApiErrors::NotFoundError)

        expect(WebMock).to have_requested(:get, "http://api.zippopotam.us/us/#{some_unallocated_zip_code}")
      end
    end
  end
end

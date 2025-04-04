require 'rails_helper'

RSpec.describe ZipCodeService do
  include ApiHelpers::Zippopotam

  describe ".find_zip_code" do
    describe "zip code with Client fetching" do
      let(:valid_zc_resp) { build_resp_valid_zip_code({ "post code".to_sym => some_florida_zip_code }) }
      let(:some_florida_zip_code) { "32024" }
      let(:some_unallocated_zip_code) { "00000" }

      context "zip code is a normal valid zip code in use" do
        it "finds the zip code and returns the cached zip on future calls" do
          client_stub = zp_stub_200_with_resp(some_florida_zip_code, valid_zc_resp)

          service_zip = ZipCodeService.find_zip_code(some_florida_zip_code)
          model_zip = ZipCode.find_by_code(some_florida_zip_code)

          expect(service_zip.id).to eq(model_zip.id)
          expect(service_zip.latitude).to_not be_nil
          expect(service_zip.longitude).to_not be_nil
          expect(service_zip.valid_zip).to be true

          service_zip_cached = ZipCodeService.find_zip_code(some_florida_zip_code)
          expect(service_zip_cached.id).to eq(service_zip.id)

          expect(client_stub).to have_been_requested.times(1)
        end
      end

      context "zip code is invalid zip code not allocated by usps" do
        it "finds the zip code and returns the cached zip on future calls" do
          client_stub = zp_stub_400_not_found(some_unallocated_zip_code)

          service_zip = ZipCodeService.find_zip_code(some_unallocated_zip_code)
          model_zip = ZipCode.find_by_code(some_unallocated_zip_code)

          expect(service_zip.id).to eq(model_zip.id)
          expect(service_zip.latitude).to be_nil
          expect(service_zip.longitude).to be_nil
          expect(service_zip.valid_zip).to be false

          service_zip_cached = ZipCodeService.find_zip_code(some_unallocated_zip_code)
          expect(service_zip_cached.id).to eq(service_zip.id)

          expect(client_stub).to have_been_requested.times(1)
        end
      end
    end

    context "zip code is already cached" do
      let!(:zip_code) { create(:zip_code) }

      it "returns the existing zip code from the database" do
        expect(ZipCodeService.find_zip_code(zip_code.code).id).to eq(zip_code.id)
      end

      it "does not call the Zip Code Api Client" do
        ZipCodeService.find_zip_code(zip_code.code)
        expect(ZippopotamClient).to_not receive(:get_zipcode_data)
      end
    end

    context "non zip code string is passed as query" do
      let(:not_even_kind_of_a_zip_code) { "Elephant!" }

      it "Throws an error without attempting an API fetch" do
        client_stub = zp_stub_200_with_resp(not_even_kind_of_a_zip_code, {})

        expect {
          ZipCodeService.find_zip_code(not_even_kind_of_a_zip_code)
        }.to raise_error(ZipCodeService::InvalidZipError)

        expect(client_stub).to have_been_requested.times(0)
      end
    end
  end
end

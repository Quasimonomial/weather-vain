require 'rails_helper'

RSpec.describe AddressService do
  include ApiHelpers::Mapbox

  describe ".get_addresses_from_query" do
    let(:indiana_query) { "Indiana" }
    let(:feature_indiana) do
      {
        properties: {
          feature_type: "region",
          full_address: "Indiana, United States",
          name: "Indiana",
          context: {
            country: { mapbox_id: "dXJuOm1ieHBsYzpJdXc", name: "United States" },
            region: { mapbox_id: "dXJuOm1ieHBsYzpBb1Rz", name: "Indiana" }
          }
        }
      }
    end
    let(:feature_indiana_place) do
      {
        properties: {
          feature_type: "neighborhood",
          full_address: "Indiana Avenue & Ransom Place, Indianapolis, Indiana, United States",
          name: "Indiana Avenue & Ransom Place",
          context: {
            postcode: { mapbox_id: "dXJuOm1ieHBsYzpDVU1PN0E", name: "46202" },
            place: { mapbox_id: "dXJuOm1ieHBsYzpDWGJJN0E", name: "Indianapolis" },
            district: { mapbox_id: "dXJuOm1ieHBsYzo0T2Jz", name: "Marion County" },
            region: {
              mapbox_id: "dXJuOm1ieHBsYzpBb1Rz",
              name: "Indiana",
              region_code: "IN"
            },
            country: {
              mapbox_id: "dXJuOm1ieHBsYzpJdXc",
              name: "United States",
              country_code: "US"
            },
            neighborhood: {
              mapbox_id: "dXJuOm1ieHBsYzpFcHFzN0E",
              name: "Indiana Avenue & Ransom Place"
            }
          }
        }
      }
    end
    let(:indiana_resp) do
      {
        type: "FeatureCollection",
        features: [ feature_indiana, feature_indiana_place ],
        attribution: "Mapbox"
      }
    end

    let(:fake_street_query) { "123 Fake Street" }
    let(:fake_street_1) do
      {
        properties: {
          context: {
            address: { name: "123 Fake Street" },
            postcode: { name: "07008" },
            place: { name: "New York City" },
            region: { region_code: "NY" },
            country: { country_code: "US" }
          }
        }
      }
    end
    let(:fake_street_2) do
      {
        properties: {
          context: {
            address: { name: "123 Fake Street" },
            postcode: { name: "94016" },
            place: { name: "San Francisco" },
            region: { region_code: "CA" },
            country: { country_code: "US" }
          }
        }
      }
    end
    let(:fake_street_resp) do
      {
        type: "FeatureCollection",
        features: [ fake_street_1, fake_street_2 ],
        attribution: "Mapbox"
      }
    end

    it "returns a formatted list of addresses from the query" do
      mb_stub_200_with_resp({
        q: fake_street_query
      }, fake_street_resp)

      addresses = AddressService.get_addresses_from_query(fake_street_query)

      expect(addresses).to eq([ {
        street_address: "123 Fake Street",
        city: "New York City",
        country: "US",
        state: "NY",
        zip_code: "07008"
      }, {
        street_address: "123 Fake Street",
        city: "San Francisco",
        country: "US",
        state: "CA",
        zip_code: "94016"
      } ])
    end

    it "filters out addresses/places that lack a postal code" do
      mb_stub_200_with_resp({
        q: indiana_query
      }, indiana_resp)

      addresses = AddressService.get_addresses_from_query(indiana_query)

      expect(addresses).to eq([ {
        street_address: nil,
        city: "Indianapolis",
        country: "US",
        state: "IN",
        zip_code: "46202"
      } ])
    end
  end
end

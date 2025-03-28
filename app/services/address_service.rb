class AddressService
  def self.get_addresses_from_query(query)
    address_data = MapboxClient.geocode_string_to_address(query)
    places = address_data[:features].select { |f|
      f[:properties][:context][:country][:country_code] == "US"
    }

    addresses = places.map do |p|
      {
        street_address: p[:properties][:context][:address][:name],
        city: p[:properties][:context][:place][:name],
        country: p[:properties][:context][:country][:country_code],
        state: p[:properties][:context][:region][:region_code],
        zip_code: p[:properties][:context][:postcode][:name]
      }
    end

    addresses
  end
end
class AddressService
  def self.get_addresses_from_query(query)
    address_data = MapboxClient.geocode_string_to_address(query)

    places = address_data[:features]

    addresses = places.map do |p|
      {
        street_address: p.dig(:properties, :context, :address, :name),
        city: p.dig(:properties, :context, :place, :name),
        country: p.dig(:properties, :context, :country, :country_code),
        state: p.dig(:properties, :context, :region, :region_code),
        zip_code: p.dig(:properties, :context, :postcode, :name)
      }
    end.select { |a| a[:zip_code].present? }

    addresses
  end
end

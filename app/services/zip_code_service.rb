class ZipCodeService
  def self.find_zip_code(zip_code_string)
    # Ignore [ZIP + 4 extended] codes for our purposes
    standard_zip_code = zip_code_string[0, 5]

    zip_code = ZipCode.find_by_code(standard_zip_code)

    if zip_code.nil?
      zc_data = ZippopotamClient.get_zipcode_data(standard_zip_code)

      if zc_data.empty? # Note: return this b/c we want to act on it in the next layer, same for errors from the client acutally
        return ZipCode.create_invalid_zip!(standard_zip_code)
      end

      zc_place_data = zc_data[:places].first

      zip_code = ZipCode.create!(
        code: standard_zip_code,
        latitude: zc_place_data[:latitude],
        longitude: zc_place_data[:longitude]
      )
    end

    zip_code
  end
end

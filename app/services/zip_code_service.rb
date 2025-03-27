class ZipCodeService
  # I think we have to truncate to the 5 digit zip code before we call this
  def self.find_zip_code zip_code_string
    standard_zip_code = zip_code_string[0, 5] # Ignore ZIP + 4 extended codes for our purpose

    zip_code = ZipCode.find_by_code(standard_zip_code)

    if zip_code.nil?
      # TODO: Handle if this fails, or if
      # zipe_code_data[:post_code] != zip_code

      puts "Zip Code Data not found in cache, fetching from api"

      zc_data = ZippopotamClient.get_zipcode_data(standard_zip_code)
      zc_place_data = zc_data[:places].first

      zip_code = ZipCode.create!(
        code: standard_zip_code,
        latitude: zc_place_data[:latitude],
        longitude: zc_place_data[:longitude]
      )
    end

    return zip_code
  end
end

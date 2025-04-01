class ZipCodeService
  class InvalidZipError < StandardError; end

  def self.find_zip_code(zip_code_string)
    # Ignore [ZIP + 4 extended] codes for our purposes
    standardized_zip_code = zip_code_string[0, 5]

    unless ZipCode.valid_zp_format?(standardized_zip_code)
      raise InvalidZipError
    end

    zip_code = ZipCode.find_by_code(standardized_zip_code)

    if zip_code.nil?
      begin
       zc_data = ZippopotamClient.get_zipcode_data(standardized_zip_code)
      rescue ApiErrors::NotFoundError
        return ZipCode.create_invalid_zip!(standardized_zip_code)
      end

      zc_place_data = zc_data[:places].first

      zip_code = ZipCode.create!(
        code: standardized_zip_code,
        latitude: zc_place_data[:latitude],
        longitude: zc_place_data[:longitude]
      )
    end

    zip_code
  end
end

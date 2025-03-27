module ResponseHelpers
  module Zippopotam
    def build_resp_used_zip_code(params = {})
      {
        "post code".to_sym => format("%05d", rand(0..99999)),
        "country": "United States",
        "country abbreviation".to_sym => "US",
        "places": [
            {
              latitude: rand(18.0..72.0).round(4),
              longitude: rand(-125.0..-65.0).round(4),
              "place name".to_sym => Faker::Address.city,
              state: Faker::Address.state,
              "state abbreviation".to_sym => Faker::Address.state_abbr
            }
        ]
      }.deep_merge!(params, merge_hash_arrays: true)
    end

    def build_resp_unused_zip_code
      {}
    end
  end
end

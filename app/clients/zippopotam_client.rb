# https://zippopotam.us/ Docs Here

class ZippopotamClient < BaseApiClient
  BASE_URL = "http://api.zippopotam.us"

  def self.conn
    @@connection ||= Faraday.new(BASE_URL)
  end

  def self.get_zipcode_data(zip_code)
    resp = conn.get("/us/#{zip_code}")
    self.parse_resp_body(resp)
  end
end

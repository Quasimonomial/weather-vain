class BaseApiClient
  class ApiKeyMissing < StandardError; end

  class << self
    attr_accessor :api_key_name
  end

  def self.parse_resp_body(resp)
    JSON.parse(resp.body, { symbolize_names: true })
  end

  # private
  def self.api_key
    raise ApiKeyMissing, "Api Key Name not defined" if self.api_key_name.nil?

    begin
      api_key = ENV.fetch(self.api_key_name)
    rescue KeyError
      raise ApiKeyMissing, "Api Key not defined: #{self.api_key_name}"
    end

    api_key
  end
end

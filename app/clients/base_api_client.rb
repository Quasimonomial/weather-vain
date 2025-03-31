require_relative "../errors/api_errors"

class BaseApiClient
  include ApiErrors

  class << self
    attr_accessor :api_key_name
  end

  def self.parse_resp_body(resp)
    JSON.parse(resp.body, { symbolize_names: true })
  end

  def self.parse_resp_error(resp)
    self.parse_resp_body(resp)
  rescue
    { error: "API resp failure" }
  end

  def self.handle_response(resp)
    api_client = self.class.to_s == "Class" ? self.to_s : self.class.to_s

    case resp.status
    when 200..299
      self.parse_resp_body(resp)
    when 400
      raise BadRequestError.new(
        status: response.status,
        response: parse_resp_error(response),
        api_client: api_client
      )
    when 401, 403
      raise AuthError.new(
        status: response.status,
        response: parse_resp_error(response),
        api_client: api_client
      )
    when 404
      raise NotFoundError.new(
        status: response.status,
        response: parse_resp_error(response),
        api_client: api_client
      )
    when 429 # :too_many_requests
      # The best thing to do is retries with retry n at 2^n seconds with jitter
      raise RateLimitError.new(
        status: response.status,
        response: parse_resp_error(response),
        api_client: api_client
      )
    when 500..599
      raise ServerError.new(
        status: response.status,
        response: parse_resp_error(response),
        api_client: api_client
      )
    else
      raise ApiError.new(
        "Unexpected status code: #{response.status}",
        status: response.status,
        response: parse_resp_error(response),
        api_client: api_client
      )
    end
  end

  private
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

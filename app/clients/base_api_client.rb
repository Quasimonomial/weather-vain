class BaseApiClient
  def self.parse_resp_body(resp)
    JSON.parse(resp.body, { symbolize_names: true })
  end
end
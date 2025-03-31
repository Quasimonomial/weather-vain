module ApiErrors
  class ApiError < StandardError
    attr_reader :status, :response, :request_data, :api_client

    def initialize(message = nil, status: nil, response: nil, request_data: nil, api_client: nil)
      @api_client = api_client
      @request_data = request_data
      @response = response
      @status = status

      super(message || default_message)
    end

    def default_message
      "API Error"
    end
  end

  class ApiKeyMissing < ApiError
    def default_message
      "Api Key not defined"
    end
  end

  class BadRequestError < ApiError # 400
    def default_message
      "Bad Request sent to external API"
    end
  end

  class AuthError < ApiError # 401, 403
    def default_message
      "Auth Error to external API"
    end
  end

  class NotFoundError < ApiError # 404
    def default_message
      "API resource not found"
    end
  end

  class RateLimitError < ApiError # 429, :too_many_requests
    def default_message
      "Rate Limited by External API"
    end
  end

  class ServerError < ApiError # 500
    def default_message
      "Interal Service Error in External Service"
    end
  end
end

class JwtService
  attr_reader :jwt

  KEY_TTL = 3.hours
  NEAR_EXP_WINDOW = 10.minutes

  def self.sign_apple_developer_key
    now = Time.now

    claims = {
      iat: now.to_i,
      exp: (now + KEY_TTL).to_i,
      iss: ENV.fetch("APPLE_WEATHERKIT_TEAM_ID"),
      sub: ENV.fetch("APPLE_WEATHERKIT_SERVICE_ID")
    }
    headers = {
      alg: "ES256",
      kid: ENV.fetch("APPLE_WEATHERKIT_KEY_ID"),
      id: "#{ENV.fetch("APPLE_WEATHERKIT_TEAM_ID")}.#{ENV.fetch("APPLE_WEATHERKIT_SERVICE_ID")}"
    }

    JWT.encode(
      claims,
      OpenSSL::PKey::EC.new(ENV.fetch("APPLE_WEATHERKIT_PRIVATE_KEY")),
      "ES256",
      headers
    )
  end

  def initialize
    @jwt = JwtService.sign_apple_developer_key
  end

  def get_valid_jwt
    if will_soon_expire
      @jwt = JwtService.sign_apple_developer_key
    end

    @jwt
  end

  def will_soon_expire
    now = Time.now.to_i

    decoded_token = JWT.decode(@jwt, nil, false)
    exp = decoded_token[0]["exp"]

    now.to_i + NEAR_EXP_WINDOW > exp
  end
end

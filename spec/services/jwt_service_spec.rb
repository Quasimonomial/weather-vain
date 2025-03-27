require 'rails_helper'

RSpec.describe JwtService do
  let!(:start_time) { Time.local(2025, 3, 25) }
  let!(:not_expired) { start_time + 1.minutes }
  let!(:exactly_in_window) { start_time + JwtService::KEY_TTL - JwtService::NEAR_EXP_WINDOW }
  let!(:almost_expired) { start_time + JwtService::KEY_TTL - JwtService::NEAR_EXP_WINDOW + 10.seconds }
  let!(:for_sure_expired) { start_time + JwtService::KEY_TTL + JwtService::NEAR_EXP_WINDOW }

  let(:jwt_service) { JwtService.new() }

  before do
    Timecop.freeze(start_time)
  end

  after do
    Timecop.return
  end

  describe ".sign_apple_developer_key" do
    it "returns a signed JWT with our apple information" do
      jwt = JwtService.sign_apple_developer_key

      decoded_token = JWT.decode(jwt, nil, false)
      claims = decoded_token[0]
      headers = decoded_token[1]

      expect(claims["iat"]).to eq(start_time.to_i)
      expect(claims["exp"]).to eq((start_time + JwtService::KEY_TTL).to_i)
      expect(headers["alg"]).to eq("ES256")

      expect(claims).to have_key("iss")
      expect(claims).to have_key("sub")

      expect(headers).to have_key("id")
      expect(headers).to have_key("kid")
    end
  end

  describe "#initialize" do
    it "intializes with a signed jwt that expires in 3 hours" do
      jwt = jwt_service.jwt
      expect(jwt).to_not be_nil
      decoded_token = JWT.decode(jwt, nil, false)
      claims = decoded_token[0]
      expect(claims["iat"]).to eq(start_time.to_i)
      expect(claims["exp"]).to eq((start_time + JwtService::KEY_TTL).to_i)
    end
  end

  describe "#get_valid_jwt" do
    it "returns the current JWT, or generates a new one if it is about to expire" do
      initial_jwt = jwt_service.jwt

      expect(jwt_service.get_valid_jwt).to eq(initial_jwt)

      Timecop.return
      Timecop.travel(not_expired)
      expect(jwt_service.get_valid_jwt).to eq(initial_jwt)

      Timecop.freeze(for_sure_expired)
      new_jwt = jwt_service.get_valid_jwt
      expect(new_jwt).to_not eq(initial_jwt)

      decoded_token = JWT.decode(new_jwt, nil, false)
      claims = decoded_token[0]
      expect(claims["iat"]).to eq(for_sure_expired.to_i)
      expect(claims["exp"]).to eq((for_sure_expired + JwtService::KEY_TTL).to_i)
    end
  end

  describe "#will_soon_expire" do
    before do
      jwt_service.get_valid_jwt()
      Timecop.return
    end

    it "returns false when key is not near expiration" do
      Timecop.travel(start_time)
      expect(jwt_service.will_soon_expire).to be false

      Timecop.travel(not_expired)
      expect(jwt_service.will_soon_expire).to be false
    end

    it "returns false when key expiration is exactly at the window" do
      Timecop.freeze(exactly_in_window)
      expect(jwt_service.will_soon_expire).to be false
    end

    it "returns true when key is near or past expiration" do
      Timecop.travel(almost_expired)
      expect(jwt_service.will_soon_expire).to be true
      Timecop.travel(for_sure_expired)
      expect(jwt_service.will_soon_expire).to be true
    end
  end
end

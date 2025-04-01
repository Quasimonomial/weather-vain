# == Schema Information
#
# Table name: zip_codes
#
#  id         :integer          not null, primary key
#  code       :string
#  latitude   :float
#  longitude  :float
#  valid_zip  :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_zip_codes_on_code  (code) UNIQUE
#
class ZipCode < ApplicationRecord
  validates :code, presence: true
  validates :latitude, :longitude, presence: true, if: :valid_zip

  validates :code, format: {
    with: /\A\d{5}\z/,
    message: "zip code must be exactly a five digit number string"
  }

  def self.create_invalid_zip!(code)
    ZipCode.create!(
      code: code,
      valid_zip: false
    )
  end

  def self.valid_zp_format?(code)
    code.match?(/\A\d{5}\z/)
  end
end

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

  def self.create_invalid_zip!(code)
    ZipCode.create!(
      code: code,
      valid_zip: false
    )
  end
end

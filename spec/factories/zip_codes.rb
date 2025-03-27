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
FactoryBot.define do
  factory :zip_code do
    add_attribute(:code) { format("%05d", rand(0..99999)) }
    add_attribute(:latitude) { rand(18.0..72.0).round(4) }
    add_attribute(:longitude) { rand(-125.0..-65.0).round(4) }
    add_attribute(:valid_zip) { true }
  end

  factory :unused_zip_code, parent: :zip_code do
    add_attribute(:latitude) { nil }
    add_attribute(:longitude) { nil }
    add_attribute(:valid_zip) { false }
  end
end

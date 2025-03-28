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

require 'rails_helper'

RSpec.describe ZipCode, type: :model do
  describe "validations" do
    let(:real_zc) { build(:zip_code) }
    let(:real_zc_no_lat) { build(:zip_code, latitude: nil) }
    let(:real_zc_no_long) { build(:zip_code, longitude: nil) }
    let(:fake_zc) { build(:unused_zip_code) }

    it { should validate_presence_of(:code) }

    it "validates latitude + longitude only on existing zip codes" do
      expect(real_zc).to be_valid
      expect(real_zc_no_lat).to_not be_valid
      expect(real_zc_no_long).to_not be_valid
      expect(fake_zc).to be_valid
    end
  end

  describe ".create_invalid_zip!" do
    it "creates and returns a zip code with false valid and nil lat/long" do
      zip_code_not_in_use = ZipCode.create_invalid_zip!("00110")

      expect(zip_code_not_in_use.persisted?).to be true
      expect(zip_code_not_in_use.latitude).to be_nil
      expect(zip_code_not_in_use.longitude).to be_nil
      expect(zip_code_not_in_use.valid_zip).to be false
    end
  end
end

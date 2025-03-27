class CreateZipCodes < ActiveRecord::Migration[8.0]
  def change
    create_table :zip_codes do |t|
      t.string :code
      t.float :latitude
      t.float :longitude

      t.timestamps
    end

    add_index :zip_codes, :code, unique: true
  end
end

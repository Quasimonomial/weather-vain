class AddExistenceBoolToZipCodes < ActiveRecord::Migration[8.0]
  def change
    add_column :zip_codes, :exists, :boolean, default: true
  end
end

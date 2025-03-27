class RenameZipCodeExistsFieldToValidField < ActiveRecord::Migration[8.0]
  def change
    rename_column :zip_codes, :exists, :valid_zip
  end
end

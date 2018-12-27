class CreateAccessCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :access_codes do |t|
      t.string :access_code
      t.timestamps
    end
  end
end

class CreateLogisticLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :logistic_locations do |t|
      t.string :name
      t.integer  :product_id

      t.timestamps
    end
  end
end

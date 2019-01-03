class CreateInbounds < ActiveRecord::Migration[5.2]
  def change
    create_table :inbounds do |t|
      t.integer  :product_id
      t.integer :logistic_location_id
      t.date  :date
      t.float  :value
      t.string :material
      t.integer :total_tons

      t.timestamps
    end
  end
end

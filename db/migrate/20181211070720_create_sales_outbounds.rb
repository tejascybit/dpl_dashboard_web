class CreateSalesOutbounds < ActiveRecord::Migration[5.2]
  def change
    create_table :sales_outbounds do |t|
      t.integer :product_id
      t.string :region
      t.string :purity
      t.string :packing
      t.string :date
      t.float :value
      t.integer :total_tons

      t.timestamps
    end
  end
end

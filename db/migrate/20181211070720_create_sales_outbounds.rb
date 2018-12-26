class CreateSalesOutbounds < ActiveRecord::Migration[5.2]
  def change
    create_table :sales_outbounds do |t|
      t.integer :product_id
      t.date :date
      t.string :region
      t.float :metric_tons
      t.integer :total_tons

      t.timestamps
    end
  end
end

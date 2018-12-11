class CreateSalesPlans < ActiveRecord::Migration[5.2]
  def change
    create_table :sales_plans do |t|
      t.integer :product_id
      t.string :region
      t.date :date
      t.float :value

      t.timestamps
    end
  end
end

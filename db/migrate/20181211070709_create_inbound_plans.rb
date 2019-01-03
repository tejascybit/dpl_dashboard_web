class CreateInboundPlans < ActiveRecord::Migration[5.2]
  def change
    create_table :inbound_plans do |t|
      t.integer :product_id
      t.integer :logistic_location_id
      t.date :date
      t.float :value
      t.string :material

      t.timestamps
    end
  end
end
